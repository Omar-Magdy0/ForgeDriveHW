# ForgeDriveHW

_Forged by passionate engineers._

ForgeDrive is an open-source research and development platform for modular, scalable, and industrial-inspired systems.

ForgeDrive is an ecosystem of reusable hardware, firmware, tools, and documentation covering the complete development process—from power electronics and embedded software to simulation, validation, and manufacturing.

The project aims to bridge the gap between academic learning, rapid prototyping, and industrial engineering practices.

### Software companion

The hardware-focused work in this repository is paired with [ForgeDrive software](https://github.com/CUERT-dev/EcoDrive), which focuses on motor-control firmware, portable generated drivers, shared libraries, Host Software-in-the-Loop (SIL), and desktop tools. Use the software repository for firmware and tooling; use this repository for board designs, electrical details, manufacturing information, and hardware bring-up. The two projects are developed as parts of the same ForgeDrive ecosystem.

---

## Repository navigation

Use the following map to find work in this repository:

| Path | Purpose |
| --- | --- |
| [`ForgeX/`](ForgeX/) | Hardware designs grouped by functional module. Each module has its own KiCad project and may contain revisions, supporting documents, simulations, and manufacturing outputs. |
| [`docs/`](docs/) | Repository documentation, including the ForgeX platform overview, generation documents, module reference documents, and images. |
| [`SharedLib/`](SharedLib/) | Shared KiCad symbols, footprints, and 3D models used by one or more board designs. |
| [`LICENSES/`](LICENSES/) | Current and legacy license texts. |
| [`docs/licensing.md`](docs/licensing.md) | Scope of the ForgeDriveHW dual-license offer and third-party licensing notes. |

### Start with the documentation

- Read [`docs/ForgeX/ForgeX.md`](docs/ForgeX/ForgeX.md) for the ForgeX modular platform architecture.
- Read [`docs/ForgeX/G0/ForgeXG0.md`](docs/ForgeX/G0/ForgeXG0.md) for the G0 generation overview.
- Use the `*_tref.md` files in [`docs/ForgeX/G0/`](docs/ForgeX/G0/) for module-specific reference documentation.

### Module directory layout

Each ForgeX module follows this general structure:

```text
ForgeX/<module>/
├── <module>.kicad_sch       # KiCad schematic (revision layout may vary)
├── <module>.kicad_pcb       # KiCad PCB layout (revision layout may vary)
├── <module>.kicad_pro       # KiCad project (revision layout may vary)
└── revA/
    ├── *.kicad_sch         # Revision-specific schematic
    ├── *.kicad_pcb         # Revision-specific PCB layout
    ├── *.kicad_pro         # Revision-specific KiCad project
    ├── Doc/                 # PDF exports, STEP models, and simulations
    ├── production/          # BOM, component positions, netlist, and iBOM
    ├── LibLocal/            # Revision-local schematic symbols and footprints
    └── ...                  # Other revision artifacts
```

Not every revision contains every optional directory. The schematic, PCB, project, and revision folders are the source of truth for a board; files in `production/` are generated manufacturing artifacts.

### Available hardware modules

| Module | Directory | Main function |
| --- | --- | --- |
| [BlackDev_G0Basic](ForgeX/BlackDev_G0Basic/) | [`ForgeX/BlackDev_G0Basic/`](ForgeX/BlackDev_G0Basic/) | Basic Black Pill development board. |
| [HBM_G0V48C15](ForgeX/HBM_G0V48C15/) | [`ForgeX/HBM_G0V48C15/`](ForgeX/HBM_G0V48C15/) | 48 V, 15 A half-bridge module. |
| [HBM_G0VH4C5](ForgeX/HBM_G0VH4C5/) | [`ForgeX/HBM_G0VH4C5/`](ForgeX/HBM_G0VH4C5/) | Half-bridge module with the HBM G0 VH4C5 topology. |
| [LVP_G0S4](ForgeX/LVP_G0S4/) | [`ForgeX/LVP_G0S4/`](ForgeX/LVP_G0S4/) | Low-voltage power module. |
| [LVP_G0S4B](ForgeX/LVP_G0S4B/) | [`ForgeX/LVP_G0S4B/`](ForgeX/LVP_G0S4B/) | Low-voltage power module variant. |
| [PMB_G0S4V80B](ForgeX/PMB_G0S4V80B/) | [`ForgeX/PMB_G0S4V80B/`](ForgeX/PMB_G0S4V80B/) | 80 V power-mechanical base module. |
| [PMB_G0S4VH4](ForgeX/PMB_G0S4VH4/) | [`ForgeX/PMB_G0S4VH4/`](ForgeX/PMB_G0S4VH4/) | Power-mechanical base module variant. |
| [PSU_G0P20N](ForgeX/PSU_G0P20N/) | [`ForgeX/PSU_G0P20N/`](ForgeX/PSU_G0P20N/) | Power supply unit module. |
| [PSU_G0V48P15R](ForgeX/PSU_G0V48P15R/) | [`ForgeX/PSU_G0V48P15R/`](ForgeX/PSU_G0V48P15R/) | 48 V, 15 A regulated power supply module. |
| [RJ45CANOpenDaisyChain_G0S2](ForgeX/RJ45CANOpenDaisyChain_G0S2/) | [`ForgeX/RJ45CANOpenDaisyChain_G0S2/`](ForgeX/RJ45CANOpenDaisyChain_G0S2/) | RJ45 CANopen daisy-chain interface. |

---

## Vision

ForgeDrive is built around one simple idea:

«Engineering should be understandable, modular, and reusable.»

Every hardware module, software component, and document is designed with long-term maintainability and extensibility in mind.

Whether developing a compact BLDC controller or a complete industrial servo drive, the same design philosophy applies:

- Modular architectures
- Well-defined interfaces
- Thorough documentation
- Reusable building blocks
- Continuous improvement through experimentation

---

## Core Principles

**Modularity**

Each subsystem has a single responsibility.

Examples include:

- Power stages
- Low-voltage distribution
- Communication modules
- Power supplies
- Signal conditioning
- Encoder interfaces
- Processing modules

Modules should be independently testable and reusable across projects.

---

**Scalability**

ForgeDrive is designed to scale across applications.

The same architecture should support:

- Laboratory prototypes
- Educational platforms
- Robotics
- CNC systems
- Industrial automation
- Research projects

---

**Engineering First**

Design decisions are driven by engineering rather than trends.

Topics documented throughout the project include:

- PCB layout
- Power electronics
- Thermal management
- EMC considerations
- Signal integrity
- Embedded software architecture
- Control algorithms
- System reliability

---

**Learning by Building**

ForgeDrive is intended to be as educational as it is practical.

Whenever possible, documentation explains:

- Why a decision was made
- Alternative approaches
- Trade-offs
- Advantages and disadvantages
- Experimental results

The goal is to share engineering knowledge—not only finished hardware.

---

## Project Scope

ForgeDrive currently explores technologies including:

### Hardware

- PMSM Inverters
- BLDC Controllers
- Three-phase power stages
- PFC converters
- Flyback power supplies
- Low-voltage power distribution
- Encoder interfaces
- Communication modules
- Protection circuitry
- High-speed PCB design

---

### Embedded Software

Firmware, portable drivers, Host Software-in-the-Loop (SIL), and desktop tools are maintained in the [ForgeDrive software repository](https://github.com/CUERT-dev/EcoDrive).

- STM32 Development
- Embedded C/C++
- CMSIS
- Low-Level Drivers
- Real-Time Systems
- Communication Protocols
- Bootloaders
- Firmware Architecture

---

### Control

- Field Oriented Control (FOC)
- Space Vector Modulation (SVM)
- Trapezoidal Control
- Current Control
- Position Control
- Speed Control
- Sensorless Algorithms

---

### Modeling & Simulation

- MATLAB / Simulink
- Model-Based Design (MBD)
- Plant Modeling
- Controller Design
- System Validation

---

### Mechanical

- Enclosures
- Thermal Design
- Mounting Systems
- Mechanical Integration

---

## Documentation

Documentation is considered a first-class component of the project.

Hardware documentation covers the physical system and its validation. For firmware architecture, driver generation, SIL workflows, and desktop tooling, see the [ForgeDrive software repository](https://github.com/CUERT-dev/EcoDrive).

Each hardware module includes:

- Board overview
- Bring-up guide
- Revision history
- Manufacturing notes
- Known issues
- Validation results

Shared documentation includes:

- System architecture
- Communication protocols
- Electrical standards
- Design guidelines
- Safety considerations
- Development workflow

---

Hardware revisions are maintained independently while Git preserves complete design history.

---

## Design Philosophy

ForgeDrive emphasizes:

- Single Responsibility Principle (SRP)
- Interface-driven design
- Reusable modules
- Hardware abstraction
- Deterministic behavior
- Debuggability
- Maintainability
- Reliability over unnecessary complexity

---

## Open Source

ForgeDrive is developed in the open.

The repository welcomes:

- Bug reports
- Suggestions
- Design discussions
- Pull requests
- Technical reviews

Constructive engineering feedback is always appreciated.

---

## Roadmap

Some long-term goals include:

- Modular PMSM inverter platform
- Modular PFC stage
- Modular power supplies
- Industrial communication modules
- FPGA acceleration
- Complete documentation
- Hardware validation reports
- Automated testing infrastructure
- Educational design guides

---

## Disclaimer

ForgeDrive contains hardware intended for development, experimentation, and learning.

Many projects involve hazardous voltages, high currents, and high-energy systems.

Always follow appropriate electrical safety practices and verify designs before use in real-world applications.

---

## License

ForgeDriveHW's original project materials are offered under the same **dual licensing** model as the [ForgeDrive software project](https://github.com/CUERT-dev/EcoDrive#license):

- Open-source use under **GNU GPLv3-only**, subject to its terms. See [`LICENSES/GPL-3.0-only.txt`](LICENSES/GPL-3.0-only.txt).
- Closed-source products and other uses that cannot comply with GPLv3 require a separate written commercial license. See [`docs/licensing.md`](docs/licensing.md) for scope and contact details.

---

## Acknowledgements

ForgeDrive is built through curiosity, experimentation, continuous learning, and a passion for engineering.

«Forged by passionate engineers.»

