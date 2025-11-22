# Contributing to HotChocolaBot

Thank you for your interest in contributing to HotChocolaBot! This educational robotics platform benefits from community contributions.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and learners
- Focus on educational value
- Provide constructive feedback
- Remember this is a learning project

## How to Contribute

### Reporting Issues

**Bug Reports**:
- Use the issue tracker
- Describe steps to reproduce
- Include error messages and logs
- Specify hardware/software versions

**Feature Requests**:
- Explain the educational value
- Describe the use case
- Consider implementation complexity
- Discuss with maintainers first

### Pull Requests

1. **Fork** the repository
2. **Create a branch**: `git checkout -b feature/your-feature-name`
3. **Make changes** following our coding standards
4. **Test thoroughly** on both mock and real hardware if possible
5. **Commit** with clear messages (see below)
6. **Push** to your fork
7. **Open a Pull Request** with detailed description

### Commit Messages

Follow this format:
```
<type>: <short summary>

<detailed description if needed>

<reference to issue if applicable>
```

**Types**:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `test:` Adding/updating tests
- `refactor:` Code refactoring
- `style:` Formatting, whitespace
- `chore:` Build process, dependencies

**Examples**:
```
feat: Add configurable observation delay for educational mode

Implements observation_delay_ms config option to slow down
operations for student observation during workshops.

Closes #42
```

## Coding Standards

### Rust Code

**Style**:
- Run `cargo fmt` before committing
- Run `cargo clippy` and fix warnings
- Follow Rust naming conventions
- Add documentation comments (`///`) for public APIs

**Safety**:
- No `unsafe` blocks without thorough justification and comments
- Validate all user input
- Handle errors explicitly (no unwrap/expect in production code except for config/startup)
- Consider safety-critical nature of hardware control

**Testing**:
- Write unit tests for new functions
- Include integration tests for modules
- Test both success and failure cases
- Mock hardware for platform-independent tests

**Example**:
```rust
/// Calculate required pump runtime for given volume.
///
/// # Arguments
/// * `volume_ml` - Volume in milliliters
/// * `flow_rate` - Pump flow rate in mL/s
///
/// # Returns
/// Runtime in milliseconds
///
/// # Examples
/// ```
/// let runtime = calculate_pump_runtime(100.0, 5.0);
/// assert_eq!(runtime, 20000); // 20 seconds
/// ```
pub fn calculate_pump_runtime(volume_ml: f32, flow_rate: f32) -> u64 {
    ((volume_ml / flow_rate) * 1000.0) as u64
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_calculate_pump_runtime() {
        assert_eq!(calculate_pump_runtime(100.0, 5.0), 20000);
        assert_eq!(calculate_pump_runtime(50.0, 10.0), 5000);
    }
}
```

### Documentation

**Markdown**:
- Use clear headings hierarchy
- Include code examples where helpful
- Add diagrams for complex concepts
- Proofread for spelling/grammar

**Code Comments**:
- Explain *why*, not *what*
- Document safety considerations
- Note educational rationale for "over-engineering"
- Use TODO/FIXME/NOTE markers appropriately

### Hardware Documentation

**When adding hardware**:
- Update BOM with suppliers and prices (UK)
- Add wiring diagram details
- Include assembly instructions
- Document safety considerations
- Test with students if possible

## Development Workflow

### Setting Up Development Environment

```bash
# Clone your fork
git clone https://github.com/YOUR-USERNAME/the-hotchocolabot.git
cd the-hotchocolabot

# Add upstream remote
git remote add upstream https://github.com/Hyperpolymath/the-hotchocolabot.git

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install development tools
rustup component add rustfmt clippy

# Run tests
cargo test

# Run locally (mock hardware)
cargo run
```

### Keeping Your Fork Updated

```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

### Running Tests

```bash
# All tests
cargo test

# Specific test
cargo test test_pump_dispense

# With logging
RUST_LOG=debug cargo test

# Doc tests
cargo test --doc

# Integration tests only
cargo test --test '*'
```

### Testing on Raspberry Pi

**Cross-compile** (on development machine):
```bash
# Install target
rustup target add armv7-unknown-linux-gnueabihf

# Build
cargo build --target armv7-unknown-linux-gnueabihf --release

# Copy to Pi
scp target/armv7-unknown-linux-gnueabihf/release/hotchocolabot pi@raspberrypi.local:~/
```

**Direct build** (on Raspberry Pi):
```bash
ssh pi@raspberrypi.local
cd ~/the-hotchocolabot
cargo build --release
sudo ./target/release/hotchocolabot
```

## Areas for Contribution

### Priority Areas

1. **Educational Materials**:
   - Additional workshop activities
   - Assessment tools refinement
   - Translations to other languages
   - Accessibility improvements

2. **Hardware Variations**:
   - Alternative component guides (different pumps, sensors)
   - Support for other platforms (Arduino, ESP32)
   - Cost-reduced versions for schools

3. **Software Features**:
   - Web interface for monitoring
   - Data logging and analysis
   - Recipe management UI
   - Mobile app for control

4. **Safety Enhancements**:
   - Additional safety checks
   - Formal verification of state machine
   - Improved error handling
   - Emergency recovery procedures

5. **Documentation**:
   - Video tutorials
   - Setup guides for specific hardware
   - Troubleshooting flowcharts
   - Internationalization

### Good First Issues

Look for issues tagged `good first issue`:
- Documentation improvements
- Additional test coverage
- Minor bug fixes
- Example recipes
- Workshop activity ideas

## Educational Philosophy

When contributing, keep in mind:

- **Over-engineering is intentional**: Complexity teaches systems thinking
- **Discovery over instruction**: Design for student-led exploration
- **Safety first**: All changes must maintain safety principles
- **Accessibility**: Make content accessible to ages 12-18 with varying backgrounds
- **Open source ethos**: Share knowledge, welcome questions, foster community

## Review Process

**Pull requests will be reviewed for**:
- Code quality and style
- Test coverage
- Documentation updates
- Educational value
- Safety considerations
- Backwards compatibility

**Expect**:
- Constructive feedback
- Requests for changes
- Discussion of design decisions
- Potential delays (maintainers are educators/researchers)

## License

By contributing, you agree that your contributions will be licensed under the same dual MIT/Apache-2.0 license as the project.

## Questions?

- **Technical questions**: Open an issue
- **Educational questions**: Contact MechCC team
- **Security concerns**: Email maintainers directly

## Acknowledgments

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in workshop materials (if applicable)

---

**Thank you for helping make robotics education more accessible!**
