# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

**DO NOT** open a public issue for security vulnerabilities.

### For Security Researchers

If you discover a security vulnerability in HotChocolaBot, please report it responsibly:

**Contact**: Create a [GitHub Security Advisory](https://github.com/Hyperpolymath/the-hotchocolabot/security/advisories/new)

**Alternatively**: Email security concerns to the maintainers (see MAINTAINERS.md)

### What to Include

1. **Description**: Clear explanation of the vulnerability
2. **Impact**: What an attacker could achieve
3. **Reproduction**: Step-by-step instructions to reproduce
4. **Affected Versions**: Which versions are vulnerable
5. **Suggested Fix**: If you have a patch or mitigation

### Response Timeline

- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 7 days
- **Fix Timeline**: Depends on severity
  - Critical: 24-48 hours
  - High: 1 week
  - Medium: 2 weeks
  - Low: Next release cycle

### Disclosure Policy

We follow **coordinated disclosure**:

1. You report the issue privately
2. We confirm and develop a fix
3. We release a patched version
4. We publicly disclose (with credit to you, if desired)
5. You may publish your findings after public disclosure

## Security Considerations for HotChocolaBot

### Hardware Safety

HotChocolaBot controls physical hardware (pumps, heaters) and must be operated safely:

**Critical Safety Systems**:
- Emergency stop button (GPIO-based)
- Temperature limits (max/min thresholds)
- Pump runtime limits (prevents overflow)
- State machine verification (prevents invalid states)

**Safety Vulnerabilities to Report**:
- Bypass of emergency stop
- Temperature limit circumvention
- State machine race conditions
- Unsafe defaults in configuration

### Electrical Safety

**Potential Issues**:
- GPIO pin misconfiguration (could damage hardware)
- Power supply issues (12V/5V mixing)
- Relay control failures
- Ground loop problems

### Software Security

**Attack Surface**:
- Configuration file parsing (TOML injection)
- I2C bus communication (device spoofing)
- GPIO control (unauthorized access)
- Filesystem access (configuration tampering)

**Currently NOT Implemented** (out of scope for educational project):
- Network interface (no remote control)
- Web UI (local only)
- Authentication (single-user device)

### Dependency Security

We use `cargo audit` in CI/CD to check for known vulnerabilities.

**Security-Critical Dependencies**:
- `rppal` - Raspberry Pi hardware access
- `tokio` - Async runtime
- `smlang` - State machine (formal verification)

**To check manually**:
```bash
cargo install cargo-audit
cargo audit
```

### Educational Context Security

**Workshop Safety**:
- Adult supervision required (per CLAUDE.md)
- Age-appropriate access to hardware
- Emergency procedures documented
- Student data privacy (GDPR compliance)

**Data Collection**:
- Workshop surveys anonymized
- Photo consent forms required
- No PII stored in repository
- Assessment data aggregated only

## Threat Model

### In Scope

1. **Physical Safety Bypass**: Vulnerabilities allowing unsafe operation
2. **Data Integrity**: Configuration tampering, sensor spoofing
3. **Dependency Vulnerabilities**: Known CVEs in dependencies
4. **Logic Errors**: State machine violations, race conditions

### Out of Scope

1. **Physical Attacks**: Disassembly, component replacement
2. **Denial of Service**: Single-user device, no network
3. **Social Engineering**: Workshop context, adult supervision
4. **Supply Chain** (for now): Hardware component authenticity

## Security Features

### Memory Safety

**Rust's guarantees**:
- No buffer overflows (bounds checking)
- No use-after-free (ownership model)
- No data races (borrow checker)
- No null pointer dereferences (Option type)

**Unsafe blocks**: Zero `unsafe` blocks in main codebase (see src/)

### Type Safety

**Compile-time guarantees**:
- Configuration validation (serde type checking)
- State machine transitions (smlang verification)
- Hardware abstraction traits (polymorphism safety)

### Runtime Safety

**Defensive programming**:
- Input validation (temperature ranges, pump durations)
- Error handling (Result types, no unwrap in production code)
- Timeouts (operation_timeout config)
- Graceful degradation (fallback to last known sensor values)

## Known Limitations

### Current Limitations

1. **No Authentication**: Single-user device, physical access required
2. **No Encryption**: Configuration in plaintext (no secrets stored)
3. **No Sandboxing**: Full GPIO/I2C access required for operation
4. **No Audit Logging**: Events logged but not cryptographically signed

These are **acceptable** for educational workshop context but would need addressing for production deployment.

### Future Enhancements

- [ ] Configuration file encryption (for commercial ingredient formulas)
- [ ] Audit log with tamper-evidence
- [ ] Read-only filesystem mode (after setup)
- [ ] WASM sandboxing for recipe plugins

## Secure Configuration Guidelines

### Recommended Settings

```toml
[safety]
max_temperature = 90.0      # Never exceed 90°C
min_temperature = 5.0       # Prevent freezing damage
max_pump_runtime = 30       # Max 30 seconds per operation
operation_timeout = 120     # 2-minute total timeout
emergency_stop_enabled = true  # ALWAYS true in production
verbose_logging = true      # Enable for audit trail
```

### Unsafe Configurations

**DO NOT**:
- Set `max_temperature > 100` (boiling point, burn hazard)
- Set `max_pump_runtime > 60` (overflow risk)
- Disable `emergency_stop_enabled`
- Run with elevated privileges unnecessarily

### File Permissions

```bash
# Configuration should be readable but not world-writable
chmod 644 config.toml

# Binary should not be setuid
ls -l target/release/hotchocolabot  # Should NOT show 's' bit
```

## Security Checklist for Deployment

Before deploying HotChocolaBot in a workshop:

- [ ] Emergency stop button tested and accessible
- [ ] Temperature sensor calibrated and verified
- [ ] Pump runtime limits configured
- [ ] All safety checks enabled in config.toml
- [ ] Raspberry Pi OS updated (sudo apt update && sudo apt upgrade)
- [ ] Dependencies audited (cargo audit)
- [ ] Adult supervision plan in place
- [ ] Emergency contact information posted
- [ ] First aid kit available (for hot liquid burns)

## Legal & Liability

**IMPORTANT**: HotChocolaBot is educational software provided "AS IS" without warranty.

**From LICENSE-MIT**:
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

**Operator Responsibilities**:
- Ensure safe operation per assembly instructions
- Supervise students at all times
- Comply with local electrical/safety regulations
- Obtain appropriate insurance for workshops
- Follow venue safety protocols

## References

- [OWASP Embedded Application Security](https://owasp.org/www-project-embedded-application-security/)
- [Rust Security Guidelines](https://anssi-fr.github.io/rust-guide/)
- [Raspberry Pi Security Best Practices](https://www.raspberrypi.org/documentation/configuration/security.md)
- [IEC 61508 (Functional Safety)](https://en.wikipedia.org/wiki/IEC_61508)

## Security Hall of Fame

We appreciate responsible disclosure. Security researchers who report valid vulnerabilities will be acknowledged here (with permission):

- _No reports yet_

---

**Last Updated**: 2024-11-22
**Version**: 1.0
