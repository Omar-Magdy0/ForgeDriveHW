---
toc: true 
toc_depth: 3  
export_on_save:
  prince: true
---

![alt](../ForgeDrive.svg)
> **Project:** ForgeX  
> **Document:** ForgeX Introduction
> **Author:** Omar Magdy  
> **Revision:** Rev. 0  
> **Status:** Development  
> **Date:** August 2026

---

# ForgeX Introduction
![alt](./Forgex.svg)
## Motivation

Forged from the need for a highly scalable, cost-effective, and
R&D-friendly power-electronics platform, the ForgeX family is designed
to bridge the gap between experimental development and field-deployable
hardware.

ForgeX is intended to remain accessible during development while
providing the architectural discipline, maintainability, and electrical
performance required for practical deployment.

The platform is designed not around a single application, but around a
family of power-electronic systems that can evolve over time.

ForgeX treats experimentation, maintainability, and serviceability as
architectural requirements rather than secondary considerations.
Hardware is intended to remain accessible for probing, modification,
replacement, and iterative development throughout its lifecycle,
from initial research and prototyping through validation and field
deployment.

## Design Principles

ForgeX is guided by the following principles:

- **Modularity** — Functions should be independently replaceable where
  practical.
- **Electrical Locality** — Electrically sensitive and high-energy
  functions should remain physically localized.
- **Defined Interfaces** — Module boundaries should be explicit and
  documented.
- **Maintainability** — Hardware should remain accessible for
  inspection, troubleshooting, and replacement.
- **Incremental Evolution** — Improvements should not require
  unnecessary redesign of unrelated subsystems.
- **Performance Preservation** — Modularity should not be achieved at
  the expense of critical electrical performance.
- **Application Scalability** — The architecture should support a
  range of power-electronic applications and topologies.

## Modular Architecture

ForgeX employs a highly modular hardware architecture in which major
engineering functions are separated into independent, self-contained
modules.

This modularity allows individual modules to be developed, tested,
characterized, revised, and replaced independently, without requiring
unnecessary changes to the remainder of the system. Where applicable,
this separation can also simplify the evaluation of individual
subsystems against relevant validation and certification requirements
before system-level integration.

The objective is not modularity for its own sake. Module boundaries are
chosen to preserve electrical locality, contain high-energy and
high-frequency phenomena, and establish clear interfaces between
engineering concerns.

ForgeX seeks to achieve modularity without compromising electrical
locality. High-current paths, high-\(di/dt\) switching loops,
gate-drive paths, local decoupling, high speed Digital Communication 
and other electrically sensitive structures are kept physically close 
to the functions they serve rather than being distributed merely for 
organizational convenience.

This allows improvements to be introduced incrementally while
minimizing disruption to established portions of the system and
preserving the electrical characteristics of critical subsystems.

## Separation of Engineering Concerns

The ForgeX hardware architecture separates major engineering concerns
into distinct functional domains, including:

- Processing and real-time control
- Industrial communication
- Power conversion and power switching
- Auxiliary low-voltage power
- Signal conditioning and measurement
- Power distribution and interconnection

These functions are connected through deliberately defined electrical
and mechanical interfaces rather than being tightly coupled into a
single monolithic control board.

This separation allows each domain to be developed, tested, and
validated according to its own requirements while maintaining a
coherent system architecture.

The separation also extends to development concerns. Changes to an
encoder technology, communication interface, control processor,
measurement subsystem, or power-stage implementation should not
inherently require redesign of unrelated portions of the system.

This enables independent development and experimentation while
maintaining well-defined boundaries between subsystems.

## Interfaces and Compatibility

The interfaces between ForgeX modules form an important part of the
architecture itself.

Interfaces are designed to establish stable electrical, mechanical,
and functional boundaries between modules. Within a generation, these
interfaces are intended to provide a defined compatibility baseline.

Across generations, compatibility is preserved selectively where the
architectural and electrical requirements remain compatible.

A new generation is therefore not required to preserve every existing
interface. Changes to interfaces should instead be deliberate,
documented, and governed by defined compatibility requirements rather
than occurring as an accidental consequence of implementation changes.

This allows ForgeX to evolve without sacrificing the benefits of a
stable modular ecosystem.

Compatibility may apply independently to different aspects of an
interface, including electrical, mechanical, functional, power, and
communication requirements. This allows future generations to retain
useful compatibility where practical while permitting architectural
changes where they provide sufficient benefit.

## Scalability and Evolution

The resulting architecture allows ForgeX to scale across a broad range
of power-electronic applications.

A system may use only a subset of the available modules for a simple
application, while more demanding systems may combine additional
processing, sensing, communication, and power modules.

The same architectural principles can therefore be applied to
different inverter and power-conversion topologies without requiring
every application to begin from an entirely independent hardware
design.

Although the initial ForgeX implementation is oriented toward
motor-control and inverter applications, the architecture is not
inherently restricted to a single application or topology. The same
principles may be applied to applications such as VFDs, compressor
drives, servo and actuator systems, renewable-energy inverters, and
more complex multi-module or multilevel power converters where the
required electrical and functional interfaces can be maintained.

ForgeX is consequently intended to be an evolving hardware family
rather than a single fixed product.

Future generations may introduce new capabilities, revise existing
modules, or replace individual implementations while preserving
selected interfaces and architectural principles established by
earlier generations.

## ForgeX Module Semantics

ForgeX defines a set of functional module classes that describe the
architectural role of a hardware module within the system.
These classifications are intended to remain independent of any particular implementation or generation. A module belonging to a given 
class may therefore be redesigned, replaced, or extended in a future
generation while retaining the same fundamental architectural role.

The base naming convention for ForgeX modules is:

`<Module Name>_G<Generation Number><Additional Specifiers>`

This convention identifies the module's architectural role and generation while allowing additional specifiers to distinguish
implementation-specific characteristics or variants.

**Example Module Names Include:**

- `HBM_G0VH4C5`
- `LVP_G0S4`
- `PMB_G0S4VH4`
- `PSU_G0P20N`

### HBM — Half-Bridge Module

The HBM provides a localized power-switching stage for the conversion
system. It integrates the high-current switching elements with their associated gate-drive, measurement, and protection circuitry, providing a self-contained power-switching stage.

The HBM is intended to keep electrically sensitive and high-\(di/dt\)
power-stage functions physically localized, while exposing defined
interfaces to the remainder of the ForgeX system.

### LVP — Low-Voltage Plane

The LVP provides the low-voltage control and signal domain of the system. It acts as an interface boundary between processing, measurement, sensing, and the power-stage hardware.

The LVP may contain signal conditioning, protection, low-voltage
interfaces, sensing infrastructure, and other circuitry required to
connect the control and processing domain to the wider system.

### PMB — Power MotherBus

The PMB provides the physical and electrical interconnection between
major power modules.

Its purpose is to distribute power and establish the required
power distribution topology while keeping the high-current infrastructure
centralized and mechanically organized.

The PMB is not intended to absorb the functions of the individual
power modules; rather, it provides the infrastructure through which
those modules are combined into a larger system.

Its implementation may range from a simple bus-bar-like structure
providing only power distribution and interconnection, to a more
integrated subsystem incorporating functions such as voltage and
current measurement, protection, monitoring, or control.

### PSU — Power Supply Module

The PSU provides auxiliary low-voltage power required by the ForgeX
system and its modules.

The PSU is treated as an independent subsystem so that auxiliary power
generation and regulation can evolve independently from the primary
power-conversion and control hardware.

### Processing / Development Modules

Processing modules provide the computational and real-time control
functions of the system.

These modules may host the primary control processor, firmware
interfaces, development infrastructure, or other computational
functions while remaining separated from the power-stage hardware.

### Interface Modules

Interface modules provide specialized connections between ForgeX and
external devices or subsystems.

These may include encoder interfaces, analog measurement,
communication, isolation, or other signal-conditioning functions.

The module classification describes the architectural responsibility
of a module, rather than prescribing a fixed PCB boundary. A future
generation may combine, split, or reorganize these functions where
doing so provides a meaningful architectural advantage while
preserving the relevant ForgeX interfaces.

For example, the Gen0 LVP integrates BISS-C and quadrature encoder
interfaces onboard while exposing a simple digital interface to the
processing domain. Future generations may instead implement these
functions as separate modules or dedicated interface devices where
doing so provides an architectural advantage.