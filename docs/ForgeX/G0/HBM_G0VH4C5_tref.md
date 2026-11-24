---
toc: true
toc_depth: 3
export_on_save:
  prince: true
---

@import "../../forgex_doc_style.css"

![](../ForgeX.svg)

# HBM_G0VH4C5 Technical Reference

> **Project:** ForgeX  
> **Generation:** Gen0  
> **Document:** HBM_G0VH4C5 Technical Reference  
> **Author:** Omar Magdy  
> **Revision:** Rev. 0  
> **Status:** Development  
> **Date:** August 2026

<div style="page-break-after: always;"></div>

## Table of Contents
[TOC]

<div style="page-break-after: always;"></div>

## 1. Introduction

The **HBM (Half-Bridge Module)** is the localized power-switching
module of the ForgeX platform. It forms the primary power-conversion
building block of the Gen0 three-phase inverter, with each inverter
phase implemented using one HBM.

The module integrates the power switches, gate-drive circuitry,
current and voltage measurement, local protection, and the associated
high-frequency switching infrastructure into a physically localized
power stage.

The Gen0 HBM implementation serves as both the first practical
implementation of the ForgeX power-stage architecture and an anchor
for subsequent HBM generations. Future implementations may revise the
power devices, gate-drive architecture, sensing, protection, or
mechanical implementation while retaining compatible architectural
interfaces where practical.

---

### 1.1 Naming

`HBM_G0VH4C5` follows the ForgeX module naming convention:

- `HBM` — Half-Bridge Module
- `G0` — Generation 0
- `VH4` — 400 V voltage class
- `C5` — 5 A nominal current class under defined operating conditions

The `C5` designation should not be interpreted as an unconditional
continuous-current rating. The achievable current depends on operating
conditions including cooling, switching frequency, thermal limits,
PCB characteristics, and the applicable electrical and EMI constraints.


### 1.2 Overview

The HBM implements a single half-bridge power stage intended to be
combined with other HBM modules through the ForgeX PMB and LVP
interfaces.

The module is designed around the principle of **electrical locality**:
the high-current switching path, gate-drive loop, local decoupling,
current sensing, and switch-node structures are kept physically close
to one another to minimize parasitic inductance and unwanted coupling.

The principal functions of the HBM are:

- High-voltage half-bridge switching
- Local MOSFET gate drive
- Phase-current measurement
- Switch-node voltage measurement
- Local fault and protection handling
- Interface to the ForgeX PMB power infrastructure
- Low-voltage control interface to the ForgeX LVP

### 1.3 Design Files

The complete hardware design files for this module are maintained in the ForgeX repository:

![](Images_G0A/HBM_G0VH4C5.pdf)

**revA:**
- [PCB & Schematic](https://github.com/Omar-Magdy0/ForgeDriveHW/tree/main/ForgeX/HBM_G0VH4C5/revA)
- [Simulation](https://github.com/Omar-Magdy0/ForgeDriveHW/tree/main/ForgeX/HBM_G0VH4C5/revA/Doc/simulation)
- **Manufacturing files:** 🛠️

---

## 2. Interfaces & I/O

![](Images_G0A/HBM0e.svg)

The HBM interfaces with the remainder of the ForgeX system through dedicated power and low-voltage interfaces.

### 2.1 Power Interface

The power interface consists of wide, dedicated copper interfaces designed
to carry the HBM power current. The interfaces can be connected using lugs
or copper spacers. The preceding figure shows the interface dimensions and
their symmetric arrangement.

| Pin Number | Pin Name | Pin Description |
|-----------:|----------|-----------------|
| 1 | `VDC` | Positive DC-link input. Connects to the positive DC bus. |
| 2 | `PHASE` | Half-bridge switched output. Connects to the motor phase or load. |
| 3 | `PGND` | Power ground and negative DC-link return. |

### 2.2 Low-Voltage Interface

The low-voltage interface uses a 2.54 mm-pitch header. The interface is
compatible with standard IDC and Dupont-style connectors.

A long-pin Dupont header may be used when access to the module's top-layer
debug and test points is desired.

| Pin Number | Pin Name | Pin Description |
|-----------:|----------|-----------------|
| 1 | `VCC` | Low-voltage supply input for the gate-driver and interface circuitry. A 12 V supply is recommended. The supply is referenced to `GND`. |
| 2 | `GND` | Low-voltage ground reference. `GND` is connected to `PGND` at a designated system-level grounding point; the HBM does not provide galvanic isolation between these domains. |
| 3 | `HIN` | High-side gate-drive control input. |
| 4 | `LIN` | Low-side gate-drive control input. |
| 5 | `NC` | No connection. Reserved for future use or left electrically unconnected. |
| 9 | `VSENSE` | Voltage-sense output proportional to the switch-node voltage. |
| 10 | `ISENSE` | Current-sense output proportional to the measured phase current. |

---

## 3. Design Requirements
Requirements are what the HBM itself is supposed to achieve:
- 400 V DC-link operation
- 5 A class power handling
- Efficient switching operation from 8–20 kHz with manageable conduction and switching losses
- Controlled switch-node ringing and voltage overshoot within component and system limits
- Current measurement bandwidth of at least 40 kHz
- Robust operation in the presence of switching noise and transients
Controlled conducted and radiated EMI to minimize interference with other system components

---

## 4. Constraints

The Gen0 HBM design is subject to several practical constraints.

A significant constraint is the limited local supply chain, with
component availability primarily governed by vendors accessible in
Egypt. Component selection therefore considers availability and
replacement options in addition to electrical performance.

PCB fabrication is constrained by the DFM rules applicable to the
available fabrication process:

- Maximum number of layers: 2
- Minimum track width: 0.25 mm
- Minimum clearance: 0.25 mm
- Minimum polygon-pour clearance: 0.3 mm
- Minimum via diameter: 0.9 mm
- Minimum via hole diameter: 0.4 mm
- Minimum annular ring: 0.5 mm
- Maximum single-board size: 38 cm × 28 cm
- Maximum double-board size: 28 cm × 22 cm

The Gen0 implementation additionally prioritizes:

- Cost effectiveness
- Component availability
- Simplicity
- Reliability
- Ease of debugging and modification
- Maintainability during development

---

## 5. Sizing and Component Selection

### 5.1 MOSFET

The selected MOSFET for the HBM power stage is the `STFH24N60M2` from STMicroelectronics. The device was selected based on its electrical characteristics, local availability, package construction, and suitability for the intended switching conditions.

**Datasheet:** [STFH24N60M2](https://www.alldatasheet.net/datasheet-pdf/view/931307/STMICROELECTRONICS/STFH24N60M2.html)

**Selection rationale:**

* **Local availability and cost:** The device is readily available from local suppliers at a relatively low unit cost, making it practical for prototyping, production, and replacement.
* **600 V drain-source rating:** The 600 V maximum `VDS` rating provides a 1.5× voltage margin over the nominal 400 V DC-link voltage. This provides additional tolerance to switching-node overshoot and transient voltage spikes.
* **High current capability:** The device is rated for up to 18 A, providing more than 3× the HBM's nominal 5 A class current rating and providing useful thermal and transient margin.
* **Low `RDS(on)`:** The maximum `RDS(on)` of 0.19 Ω and typical value of approximately 0.168 Ω help reduce conduction losses during normal operation.
* **Low gate charge:** The total gate charge of approximately 29 nC, with a Miller charge of approximately 12 nC, reduces the gate-drive charge requirement and allows the device to be switched effectively at the HBM's intended operating frequencies.
* **Insulated mounting tab:** The insulated package tab simplifies mechanical mounting and allows multiple MOSFETs to share a common heatsink without requiring electrical isolation between the devices and the heatsink.
* **Body-diode performance:** The body diode has comparatively acceptable reverse-recovery characteristics for a silicon MOSFET in this voltage and price class. This helps reduce reverse-recovery-related switching losses and transient currents in the half-bridge.

### 5.2 Gate Drive

The selected gate-driver IC for the HBM is the `L6388` from STMicroelectronics.

**Datasheet:** [L6388](https://www.st.com/resource/en/datasheet/l6388.pdf)

**Selection rationale:**

* **Local availability and cost:** The device is readily available from local suppliers at a relatively low unit cost, making it practical for prototyping, production, and replacement.
* **600 V high-side operating capability:** The high-voltage section is rated for operation up to 600 V, providing an appropriate voltage rating for the HBM's nominal 400 V DC-link.
* **High gate-drive current:** The driver provides up to **400 mA source current** and **650 mA sink current**, providing sufficient drive capability for the selected MOSFET at the intended switching frequencies.
* **Integrated interlock and deadtime:** The device incorporates half-bridge interlock logic and internal deadtime generation, with a typical deadtime of approximately **320 ns**. This provides protection against simultaneous turn-on of the high-side and low-side MOSFETs.
* **Integrated bootstrap diode:** The high-side driver requires a bootstrap supply to operate. The L6388 integrates the bootstrap diode internally, eliminating the need for an external high-voltage fast-recovery diode and its associated series components. This reduces component count and simplifies the gate-drive implementation.
### 5.3 External Components

The external components of the gate-drive circuit were selected based on the required switching speed, gate-drive current, bootstrap supply requirements, and supply decoupling.
#### 5.3.1 Gate Resistor

The external gate resistor was selected to establish the initial switching-speed
target while providing a practical compromise between switching losses,
switch-node `dv/dt`, deadtime-related losses, voltage overshoot, and ringing.

An initial target of approximately **100 ns turn-on** and **80 ns turn-off**
was selected. The resulting target switch-node slew rates are approximately:

- **Turn-on slew:** \(\leq 5\,\mathrm{V/ns}\)
- **Turn-off slew:** \(\leq 5.5\,\mathrm{V/ns}\)

These values provide a controlled switching transition while keeping the
switching losses within an acceptable range.

**First-Order Switching Loss Estimate**

A first-order estimate of the switching loss of a single MOSFET is:

\[
P_{SW}
\approx
\frac{1}{2}V_{DS}I_D(t_{on}+t_{off})f_{SW}
\]

For a **400 V DC-link**, **5 A DC current**, and **20 kHz switching
frequency**, the switching loss is estimated as:

\[
P_{SW}
\approx
\frac{1}{2}
\times400
\times5
\times(100+80)
\times10^{-9}
\times20\times10^{3}
\]

\[
P_{SW}\approx3.6\,\mathrm{W}
\]

This is a first-order estimate of the voltage-current overlap loss and does
not include other switching-related losses such as \(E_{OSS}\), body-diode
reverse-recovery losses, gate-drive losses, or additional losses associated
with switch-node ringing.

**Gate Current and Gate Resistor**

The gate current required during the Miller transition can be estimated from
the MOSFET Miller charge:

\[
I_G\approx\frac{Q_{Miller}}{t_{Miller}}
\]

For the selected `STFH24N60M2`:

\[
Q_{Miller}\approx12\,\mathrm{nC}
\]

**Turn-On**

For a target turn-on time of approximately **100 ns**:

\[
I_{G,on}
=
\frac{Q_{Miller}}{t_{on}}
\]

\[
I_{G,on}=120\,\mathrm{mA}
\]

The gate current can alternatively be estimated from the gate-drive voltage
and total gate-path resistance:

\[
I_{G,on}
=
\frac{V_{DRV}-V_{PL}}
{R_{GateInternal}+R_{GateDriverSource}+R_{GateExternal}}
\]

Using:

\[
\begin{aligned}
V_{DRV} &= 12\,\mathrm{V} \\
V_{PL} &\approx 5.5\,\mathrm{V} \\
R_{GateInternal} &= 7\,\Omega
\qquad\text{(MOSFET intrinsic gate resistance)}\\
R_{GateDriverSource} &= 37.5\,\Omega
\qquad\text{(L6388 datasheet)}\\
R_{GateExternal} &\approx 10\,\Omega
\end{aligned}
\]

**Turn-Off**

For a target turn-off time of approximately **80 ns**:

\[
I_{G,off}
=
\frac{Q_{Miller}}{t_{off}}
\]

\[
I_{G,off}=150\,\mathrm{mA}
\]

The turn-off gate current can similarly be estimated from:

\[
I_{G,off}
=
\frac{V_{PL}}
{R_{GateInternal}+R_{GateDriverSink}+R_{GateExternal}}
\]

Using:

\[
\begin{aligned}
V_{PL} &\approx 5.5\,\mathrm{V} \\
R_{GateInternal} &= 7\,\Omega
\qquad\text{(MOSFET intrinsic gate resistance)}\\
R_{GateDriverSink} &= 23\,\Omega
\qquad\text{(L6388 datasheet)}\\
R_{GateExternal} &\approx 10\,\Omega
\end{aligned}
\]

The source and sink paths have similar overall external gate resistance
requirements, while the L6388 has different source and sink output
impedances. Therefore, a single external gate resistor is considered
adequate for the initial design.

Separate turn-on and turn-off resistors can be introduced later if
measurements indicate that additional asymmetric switching control is
required.

**`dv/dt` Constraints**

The selected switching speed is evaluated against the principal `dv/dt`
constraints associated with the MOSFET, gate driver, and half-bridge
configuration.

**Miller-Induced False Turn-On**

When the complementary MOSFET switches, the switch-node `dv/dt` couples
through the gate-drain (Miller) capacitance of the MOSFET that is in the
OFF state.

The resulting Miller current can be approximated by:

\[
I_{Miller}
=
C_{GD}(V_{DS})
\frac{dV_{DS}}{dt}
\]

A first-order estimate of the `dv/dt` limit for Miller-induced false
turn-on is:

\[
\left(\frac{dV}{dt}\right)_{Miller,Limit}
=
\frac{V_{TH}}
{
(R_{GateInternal}
+
R_{GateDriver}
+
R_{GateExternal})
C_{Miller}
}
\]

Using the relevant high-\(V_{DS}\) Miller-capacitance region gives an
estimated limit of:

\[
\boxed{
\left(\frac{dV}{dt}\right)_{Miller,Limit}
\approx34\,\mathrm{V/ns}
}
\]

This value is a first-order estimate rather than an absolute MOSFET
`dv/dt` rating. The actual false-turn-on behavior depends on the nonlinear
\(C_{GD}(V_{DS})\) characteristic, MOSFET threshold voltage, temperature,
gate-loop impedance, and parasitic inductances.

The intended switch-node slew rates therefore remain substantially below
the estimated Miller-induced false-turn-on limit.

**Gate-Driver `dv/dt` Immunity**

The L6388 gate driver specifies a `dv/dt` immunity of approximately:

\[
\boxed{
\left(\frac{dV}{dt}\right)_{Driver,Limit}
\approx50\,\mathrm{V/ns}
}
\]

The selected switching-speed target remains below this limit.

**MOSFET `dv/dt` Ruggedness**

The selected MOSFET has a specified `dv/dt` ruggedness of approximately:

\[
\boxed{
\left(\frac{dV}{dt}\right)_{MOSFET,Limit}
\approx50\,\mathrm{V/ns}
}
\]

This is substantially above the intended average switch-node slew rate.

**`di/dt` and Parasitic-Inductance Voltage**

The current slew rate through parasitic inductance generates an additional
voltage according to:

\[
V_L=L_{par}\frac{di}{dt}
\]

For a **5 A DC load** and an assumed current transition occurring over
approximately **100 ns**:

\[
\frac{di}{dt}
\approx
\frac{5\,\mathrm{A}}{100\,\mathrm{ns}}
=
0.05\,\mathrm{A/ns}
\]

For an estimated switching-loop inductance of:

\[
L_{Power}\approx20\,\mathrm{nH}
\]

the corresponding inductive voltage is:

\[
V_{L,Power}
\approx
20\,\mathrm{nH}
\times
0.05\,\mathrm{A/ns}
\approx1.0\,\mathrm{V}
\]

The estimated source inductance additionally produces a source-voltage
excursion:

\[
V_{L,Source}
=
L_{Source}\frac{di}{dt}
\]

For:

\[
L_{Source}=7\,\mathrm{nH}
\]

the first-order estimate is:

\[
V_{L,Source}
\approx
7\,\mathrm{nH}
\times
0.05\,\mathrm{A/ns}
\approx0.35\,\mathrm{V}
\]

The combined first-order inductive voltage contribution is therefore:

\[
\boxed{
V_{L,Total}
\approx
1.0\,\mathrm{V}+0.35\,\mathrm{V}
\approx1.35\,\mathrm{V}
}
\]

This estimate represents the inductive voltage generated by the assumed
current slew and does not account for resonant ringing, parasitic
capacitances, diode reverse recovery, or other transient mechanisms.
It therefore serves as a first-order estimate of the expected inductive
transient prior to detailed simulation and measurement.
#### 5.3.2 Bootstrap Capacitor

The bootstrap capacitor provides the local energy reservoir and low-impedance current path required to drive the high-side MOSFET. Because the high-side gate is charged through this capacitor, its value must be sufficiently large to maintain the bootstrap supply above the gate driver's high-side UVLO threshold throughout the switching cycle.

A simple design rule is to select the bootstrap capacitance as at least ten times the effective gate capacitance of the MOSFET. As a general rule of thumb, the capacitor should store sufficient charge to drive the high-side MOSFET without its voltage being depleted by more than approximately 10% during a switching cycle:

\[
C_{BOOT} \geq 10C_G
\]

where the effective gate capacitance can be approximated from the MOSFET total gate charge:

\[
C_G = \frac{Q_G}{V_{Q1g}}
\]

For the selected `STFH24N60M2`:

\[
Q_G \approx 30\,\mathrm{nC}
\]

and the target gate-drive voltage is:

\[
V_{Q1g} \approx V_{GS} = 12\,\mathrm{V}
\]

Therefore:

\[
C_G \approx \frac{30\,\mathrm{nC}}{12\,\mathrm{V}}
\approx 2.5\,\mathrm{nF}
\]

and the simple 10× rule gives:

\[
C_{BOOT} \geq 25\,\mathrm{nF}
\]

This provides a useful lower-bound estimate; however, the actual bootstrap capacitor should also account for MOSFET gate charge, gate-driver quiescent and leakage currents, maximum duty cycle, bootstrap-diode voltage drop, capacitor tolerance, DC-bias derating, and the allowable bootstrap-voltage ripple.

A substantially larger **1 µF** bootstrap capacitor was selected for the HBM.

**Justification:**

The larger capacitor was intentionally selected to provide substantial charge reserve rather than minimizing the capacitance to the theoretical requirement. The bootstrap supply is fundamentally a charge-balance system, and the capacitor voltage decreases according to the charge removed from it:

\[
\Delta V_{BOOT} = \frac{\Delta Q}{C_{BOOT}}
\]

For a single high-side switching event, the MOSFET requires approximately:

\[
Q_G \approx 30\,\mathrm{nC}
\]

Ignoring the additional driver leakage and quiescent-current contributions, the corresponding voltage change of the selected 1 µF capacitor is only:

\[
\Delta V_{BOOT}
\approx
\frac{30\,\mathrm{nC}}{1\,\mathrm{\mu F}}
=
30\,\mathrm{mV}
\]

Therefore, even over ten consecutive high-side switching events without a significant bootstrap refresh:

\[
\Delta V_{BOOT,10}
\approx
10\times30\,\mathrm{mV}
=
300\,\mathrm{mV}
\]

The resulting small voltage droop provides substantial tolerance to skipped or shortened bootstrap recharge intervals and allows the high-side driver to maintain a stable gate-drive voltage during transient operating conditions.

The larger capacitance also provides increased immunity to variations in MOSFET gate charge, gate-driver consumption, capacitor tolerance, temperature, and other charge losses. The bootstrap capacitor therefore has considerable charge reserve relative to the approximately 30 nC gate-charge requirement.

The principal trade-off is the increased charge required to initially charge the bootstrap capacitor and initial charge time to
\[ 0.9=(1−e^{\frac{−t}{\tau}}) \\[8pt]
\tau=\frac{125 \Omega}{1\,\mathrm{uF}} \\[8pt]
t=290\,\mathrm{uS}
\]
The bootstrap charging path, including the integrated bootstrap diode of the `L6388`, must therefore accommodate the associated charging current. This was considered acceptable for the selected implementation, while the resulting increase in bootstrap hold-up capability provides a useful robustness margin.

The selected value should consequently be understood as a **hold-up and robustness choice**, rather than a minimum capacitance requirement.

#### 5.3.3 VCC Decoupling Capacitor

The gate-driver supply requires a local decoupling capacitor to provide the high-frequency current demanded by the gate-drive output stage and to minimize voltage sag and supply-loop inductance during switching transitions.

As an initial design rule, the local VCC decoupling capacitance is selected as:
\[
C_{VCC} \geq 10C_{BOOT}=10\,\mathrm{uF}
\]

This provides a substantially larger local energy reservoir than the bootstrap capacitor and helps maintain a stable gate-driver supply during high-current switching transitions.

The decoupling capacitor should be placed directly adjacent to the `L6388` VCC and GND pins, minimizing the associated PCB loop area and parasitic inductance.

#### 5.3.4 RC Snubber

A first-pass RC snubber value was estimated from the effective switching-loop
inductance and the MOSFET parasitic capacitance. The initial values are:

\[
C_{snub}\approx 4\times C_{oss}\approx220\,\mathrm{pF} \\[4pt]
R_{snub}\approx\sqrt{\frac{L_0}{C_{oss}}}\approx 25\,\Omega
\]

where \(L_0\) represents the estimated high-frequency switching-loop
inductance, including relevant MOSFET package and interconnect inductance.

These values provide an initial damping network for the switch-node
LC resonance. The final snubber values are to be determined experimentally
or through switching-waveform simulation by evaluating the resulting
overshoot, ringing, switching losses, and snubber dissipation.


### 5.4 Current Sensing

Since galvanic isolation is not enforced between the power and logic domains, low-side shunt current sensing is employed to provide a cost-effective and compact current measurement solution. The shunt is placed in the low-side current return path, allowing the resulting differential voltage to be amplified with respect to the local logic ground.

The `TP181A1` current-sense amplifier from 3PEAK is employed for this function.

**Datasheet:** [TP181A1](https://www.lcsc.com/datasheet/C2902351.pdf)

**Selection rationale:**

* **Local availability and cost:** The device is readily available from local suppliers at a relatively low unit cost, making it practical for prototyping, production, and field replacement.
* **Wide supply-voltage range:** The device operates from \(2.7\,\mathrm{V}\) to \(30\,\mathrm{V}\), providing substantial supply-voltage margin for the 3.3 V logic domain.
* **High CMRR:** A typical common-mode rejection ratio (CMRR) of \(120\,\mathrm{dB}\) provides strong rejection of common-mode voltage appearing across the shunt during switching transients.
* **Low gain error:** A typical gain error of \(\pm 0.1\%\) provides good measurement accuracy without requiring extensive gain calibration.
* **High bandwidth:** The \(48\,\mathrm{kHz}\) bandwidth is sufficient for the intended current-feedback and monitoring applications while providing adequate response to the current waveform.
* **High fixed gain:** The \(50\,\mathrm{V/V}\) gain allows the use of a low-value shunt resistor, reducing the power dissipated in the current-sensing path while still providing a useful ADC signal amplitude.

**Shunt Resistor Selection**

The shunt resistance is selected as a trade-off between measurement range, signal utilization, and power dissipation. For the nominal \(6.5\,\mathrm{A}\) peak-current version of the module, a \(5\,\mathrm{m\Omega}\) shunt resistor is employed. Higher-current variants can use proportionally lower shunt resistance values to reduce the voltage drop and associated power dissipation.

The shunt amplifier is biased at the midpoint of the \(3.3\,\mathrm{V} \) ADC range:

\[
V_{bias} = \frac{3.3}{2}\,\mathrm{V}
\]

This allows the same ADC input to represent both positive and negative current, with the zero-current condition centered around \(1.65\,\mathrm{V}\).

For a \(5\,\mathrm{m\Omega}\) shunt and a fixed amplifier gain of \(50\,\mathrm{V/V}\), the sensed voltage is:

\[
V_{signal} = I \times 50 \times R_{shunt} + \frac{3.3}{2}
\]

Substituting the selected shunt resistance:

\[
V_{signal} = I \times 0.25\,\mathrm{V/A} + 1.65\,\mathrm{V}
\]

Thus, the current-sensing path provides a measurement gain of \(0.25\,\mathrm{V/A}\), with the nominal \(0\,\mathrm{A}\) point located at \(1.65\,\mathrm{V}\).

Ideally, the \(0 \rightarrow 3.3\,\mathrm{V} \) ADC range corresponds to approximately:

\[
I_{max} = \frac{3.3-1.65}{0.25} = 6.6\,\mathrm{A}
\]

\[
I_{min} = \frac{0-1.65}{0.25} = -6.6\,\mathrm{A}
\]

giving a theoretical bidirectional measurement range of approximately:

\[
\pm 6.6\,\mathrm{A}
\]

In practice, the usable range is slightly lower due to amplifier output swing, offset, gain error, ADC tolerances, and the desired operating margin from the ADC rails.

**Shunt Power Dissipation**

The power dissipated by the shunt resistor is determined by the RMS current flowing through it:

\[
P_{shunt} = I^2 \times R_{shunt}
\]

At the nominal \(6.5\,\mathrm{A}\) current level:

\[
P_{shunt} = 6.5^2 \times 5\,\mathrm{m\Omega}
\approx 0.21\,\mathrm{W}
\]

A (2512) footprint is used for the shunt resistor. Depending on the selected resistor technology and manufacturer, (2512) shunts with power ratings up to approximately \(1\,\mathrm{W}\) are readily available, providing substantial thermal margin relative to the nominal dissipation.

**Valid Measurement Window**

Because the shunt is located in the low-side current path, the current-sense signal is only representative of the phase current while the corresponding low-side MOSFET provides the active current-return path. During the high-side conduction interval, the shunt is outside the primary current path and therefore cannot provide continuous phase-current information.

Additionally, the measurement should not be sampled immediately after the low-side MOSFET is enabled. The switching transition can contain MOSFET reverse-recovery current, capacitive displacement current, commutation current, and other transient components that do not accurately represent the steady-state load current.

A minimum blanking interval of approximately \(300\,\mathrm{ns}\) after low-side MOSFET turn-on is therefore recommended before sampling the shunt amplifier output. The exact blanking time should ultimately be verified against the measured switching waveform, amplifier settling behavior, and the operating conditions of the specific power stage.


### 5.5 Voltage Sensing

For the `HBM_G0VH4C5`, galvanic isolation is not enforced between the power and logic domains, and `PGND` and `LGND` are therefore required to be connected at a defined point within the system. This permits the switch-node voltage to be sensed directly with respect to `LGND` using a high-voltage resistive divider.

The divider ratio is selected such that the maximum expected switch-node voltage is mapped into the valid 0--3.3 V range of the analog sensing circuitry:

\[
V_{signal} = V_{sw} \times \frac{3.3\,\mathrm{k}}{450\,\mathrm{k}+3.3\,\mathrm{k}}
\]

This gives the following nominal full-scale mapping:

\[
450\,\mathrm{V} \rightarrow 3.276\,\mathrm{V}
\]

The resulting scaling makes effective use of the available ADC input range while retaining a small margin below the 3.3 V rail. The divider is implemented as a series string of high-voltage resistors so that the voltage stress across each individual component remains within its rated working voltage. The physical implementation also maintains the required creepage and clearance distances across the high-voltage portion of the divider.

The power dissipated by the divider under a 400 V DC switch-node condition is approximately:

\[
P_{divider} = \frac{400^2}{450\,\mathrm{k}+3.3\,\mathrm{k}}
\approx 0.353\,\mathrm{W}
\]

This dissipation is distributed across the series resistor string rather than concentrated in a single component, reducing the voltage and power stress on each individual resistor.

The switch-node measurement is particularly useful in operating conditions where the half-bridge is in a high-impedance state, with both MOSFETs turned off. In this condition, the switch-node voltage is no longer actively driven by either device and can provide useful information about the external load, motor phase, or commutation state. This makes the sensing path applicable to control and diagnostic functions such as high-impedance phase-voltage measurement in motor-control applications.

### 5.6 References

* [TI — Bootstrap Circuitry Selection for Half-Bridge Configurations](https://www.ti.com/lit/an/slua887a/slua887a.pdf)
* [Infineon — Using Monolithic High-Voltage Gate Drivers](https://www.infineon.com/row/public/documents/24/42/infineon-using-monolithic-high-voltage-gate-drivers-applicationnotes-en.pdf)
* [Seminar 1400 Topic 2 APDX Estimating MOSFET Parameters from the Data Sheet](https://www.ti.com/lit/ml/slup170/slup170.pdf?ts=1786803369734)

---

## 6. Simulation

Simulation is used as a first-pass validation and design tool for the
HBM.

The simulations are intended to:

- Validate initial electrical estimates
- Evaluate the effects of layout-related parasitics
- Assist with component sizing
- Investigate switching behavior and transient effects
- Provide a basis for first-pass design tuning

Simulation results are not considered a substitute for physical testing
and validation. Their accuracy depends on the quality, fidelity, and
applicability of the underlying semiconductor, parasitic, and system
models.

The primary simulation focus is the power-electronics behavior of the
module and its associated switching infrastructure.

### 6.1 MOSFET Model

An LTspice VDMOS-based MOSFET model was developed for the selected
`STFH24N60M2`. The model parameters were tuned and tested against the
available datasheet characteristics and test conditions.

The model-development process was assisted by the
[Hendrik Jan Zwerver LTspice VDMOS modeling guide](http://www.magma.ca/~legg/SR5/LTspice_build_in_VDmos_model.pdf).

The following test circuits are provided under `simulation/`:

- `simulation/STFH24N60M2_test_bodyDiode.asc` — DC body-diode characteristics
- `simulation/STFH24N60M2_test_bodyDiode2.asc` — Double-pulse test and reverse-recovery tuning
- `simulation/STFH24N60M2_test_cap.asc` — MOSFET parasitic-capacitance characterization
- `simulation/STFH24N60M2_test_outChar.asc` — Output characteristics
- `simulation/STFH24N60M2_test_tranChar.asc` — Transfer characteristics

![alt text](Images_G0A/stfh24n60m2_ltspice.png)

**Model Tuning Approach**

The model was tuned primarily around the intended operating point rather
than attempting to reproduce every datasheet characteristic with equal
accuracy.

The LTspice VDMOS model provides a limited set of degrees of freedom
compared with a detailed manufacturer subcircuit. Consequently, the
available parameters were selected and adjusted to provide useful
agreement with the MOSFET behavior in the operating region relevant to
the HBM.

For example, parameters such as \(K_P\) were tuned around the intended
operating drain-current region rather than being optimized solely for
accuracy in the saturation region.

Datasheet test circuits and their corresponding operating conditions were
used as references during parameter tuning.

This approach represents a deliberate compromise between **model
accuracy and simulation performance**. A detailed manufacturer
subcircuit could potentially provide greater fidelity across a wider
range
of operating conditions, but the VDMOS-based model provides a simpler and
faster model for iterative power-electronics simulation.

### 6.2 MOSFET Gate-Driver Model

A behavioral LTspice model of the `L6388` gate driver was developed to
reproduce the relevant characteristics of the gate-driver IC and its
interaction with the MOSFET.

The model was developed using the available datasheet information and
tuned against the specified gate-driver characteristics, including:

- Logic-input thresholds and hysteresis
- Propagation delays
- Typical deadtime
- Gate-source and gate-sink output impedance
- UVLO behavior
- Internal bootstrap-diode behavior

![alt text](Images_G0A/l6388_ltspice.png)

The model is primarily intended to reproduce the gate driver's switching
behavior and its interaction with the MOSFET gate network rather than to
model the internal semiconductor implementation of the IC.

The following test circuit is provided under `simulation/`:

- `simulation/L6388_test.asc` — Gate-driver sourcing and sinking behavior using a
  `1000 pF` load, used to compare the behavioral model against the
  datasheet characteristics.

### 6.3 HBM_G0VH4C5 Module Model

A simulation model was developed for the `HBM_G0VH4C5` module to
evaluate the electrical behavior of the complete half-bridge power stage.

The model includes representations of:

- Voltage-sensing behavior
- Current-sensing behavior
- MOSFET package parasitics
- Power-input connection inductance
- High-frequency switching-loop inductance
- Gate-drive loop inductance
- Shunt-resistor behavior
- Other first-order parasitic elements relevant to the module

![alt text](Images_G0A/hbm_g0vh4c5_ltspice.png)

The model is intended to provide a first-order representation of the
module's electrical behavior and to evaluate the interaction between the
power stage, gate-drive circuitry, sensing circuitry, and parasitic
elements.

### 6.4 Inductive-Load Single-Leg Inverter Test

The single-leg inverter model serves as a performance indicator for the
`HBM_G0VH4C5` power stage.

It provides a simplified environment for evaluating:

- Switching behavior
- Gate-drive performance
- Commutation behavior
- Switch-node voltage overshoot and ringing
- Load-current behavior
- Estimated switching losses
- Effects of parasitic inductance and resistance

The test environment is intentionally simpler than the complete
system-level inverter, allowing individual characteristics of the HBM
power stage to be evaluated before system-level integration.

The single-leg inverter simulations include expected parasitic
impedances of approximately:

\[
R_{PGND-LGND}=10\,\mathrm{m\Omega}
\]

and:

\[
L_{PGND-LGND}=20\,\mathrm{nH}
\]

between `PGND` and `LGND` for typical expected applications of the
module.

These parasitic elements allow the simulation to investigate logic
reference shifts, ground bounce, common-impedance coupling, and related
noise/EMI effects resulting from the interaction between the power and
logic domains.

#### 6.4.1 SLinverter Test0

**Simulation file:** `simulation/HBM_SLinverter_test.asc`

This test applies a **100 kHz PWM signal with 50% duty cycle** and no
sinusoidal carrier to a **2 kW RL load** with:

\[
L_{Load}=10\,\mu\mathrm{H}
\]

The load resistance was selected to correspond to approximately 2 kW
operation.


**Load Resistor Sizing**
\[
\begin{aligned}
V_{A} &= V_{VDCH}/2  \\[4pt] 
V_{n,RMS} &= \frac{4V_{A}}{nπ \sqrt{2}} \\[4pt]
V_{1,RMS} &= 180 \\[4pt]
V_{3,RMS} &= 60 \\[4pt]
XL_1&​=2πfL≈6.28Ω \\[4pt]
XL_2&​=3\times2πfL≈18.85Ω \\[4pt]
P_{Load} &= \frac{V_{1,RMS}^2R_{Load}}{R_{Load}^2+XL_{1}^2} + \frac{V_{3,RMS}^2R_{Load}}{R_{Load}^2+XL_{3}^2} \\[4pt]
R_{Load} &= 14.21\,\Omega, 2.92\,\Omega \quad\text{(Choosing 14.21 for lower peak current)} \\[4pt] 
R_{Load}& \approx14\,\Omega
\end{aligned}
\]

**Split-Rail Capacitor Sizing**
\[
 C ≥ \frac{\sqrt{2}I_{rms}}{2 \pi f_{SW}ΔV}
\]
choosing a 20uF per cap results in 
\[
 ΔV = 1.35V \\[4pt]
 V_{midpoint} = 200 \pm 1.35
\]

**Results & Notable Plots**
![alt](Images_G0A/SLinvtest0_LoadVoltageCurrent.svg)
![alt](Images_G0A/SLinvtest0_SwitchNodeVoltage.svg)
![alt](Images_G0A/SLinvtest0_GateCurrents.svg)
![alt](Images_G0A/SLinvtest0_HighSideTurnOnOff.svg)

    HBM INVERTER SLinverter Test0 RESULTS
    --- Power ---
    Efficiency interval : 1.500 -> 1.700 ms
    Average input power : 2016.217 W
    Average output power: 1969.905 W
    Efficiency          : 97.703 %
    --- MOSFET Losses ---
    High-side avg loss  : 19.066 W
    Low-side avg loss   : 18.833 W
    Total MOSFET loss   : 37.899 W
    --- VDS Stress ---
    High-side VDS max   : 418.979 V
    Low-side VDS max    : 418.874 V
    High-side VDS min   : -11.204 V
    Low-side VDS min    : -11.046 V

---

#### 6.4.2 SLinverter Test1

**Simulation file:** `simulation/HBM_SLinverter_test1.asc`

This test applies a **10 kHz sinusoidal PWM signal** with a modulation
index of:

\[
m=0.92
\]

to a **2 kW RL load** with:

\[
L_{Load}=1\,\mathrm{mH}
\]

The load resistance was selected to correspond to approximately 2 kW
operation.

**Load Resistor Sizing**
\[
\begin{aligned}
V_{A} &= V_{VDCH}/2  \\[4pt] 
V_{1,RMS} &= m\times \frac{200}{\sqrt{2}} = 130.1 \\[4pt]
XL&​=2πfL≈0.314\Omega \\[4pt]
P_{Load} &= \frac{V_{1,RMS}^2R_{Load}}{R_{Load}^2+XL^2} \\[4pt]
R_{Load} &= 8.45\,\Omega,  11.66\,m\Omega \quad\text{(Choosing 8.45 for lower peak current)} \\[4pt] 
R_{Load} &\approx8.5\,\Omega
\end{aligned}
\]

**Split-Rail Capacitor Sizing**
\[
 C ≥ \frac{\sqrt{2}I_{rms}}{​2\pi f_{elec}ΔV} \\[4pt]
 ΔV = 13.5 \\[4pt]
 C \approx 5\,\mathrm{mF} \\[4pt]
 V_{midpoint} = 200 \pm 13.5 \\[4pt]
\]


**Results & Notable Plots**
![alt](Images_G0A/SLinvtest1_LoadVoltageCurrent.svg)
![alt](Images_G0A/SLinvtest1_SwitchNodeVoltage.svg)
![alt](Images_G0A/SLinvtest1_GateCurrents.svg)
![alt](Images_G0A/SLinvtest1_HighSideTurnOnOff.svg)

    HBM INVERTER SLinverter Test0 RESULTS
    --- Power ---
    Efficiency interval : 24 -> 44 ms
    Average input power : 1934.394 W
    Average output power: 1872.306 W
    Efficiency          : 96.790 %
    --- MOSFET Losses ---
    High-side avg loss  : 26.604 W
    Low-side avg loss   : 23.628 W
    Total MOSFET loss   : 50.232 W
    --- VDS Stress ---
    High-side VDS max   : 428.413 V
    Low-side VDS max    : 434.378 V
    High-side VDS min   : -13.069 V
    Low-side VDS min    : -13.109 V

### 6.5 Digest and Conclusion

The single-leg inverter simulations provide a first-pass validation of the
`HBM_G0VH4C5` power stage under both high-frequency hard-switching and
sinusoidal PWM operating conditions.

The simulations confirm the expected overall switching behavior and provide
an initial assessment of the following key design aspects:

- MOSFET switching and commutation behavior
- Gate-driver operation and gate-drive waveforms
- Switch-node voltage overshoot and ringing
- MOSFET voltage stress
- Load-current behavior
- Estimated MOSFET switching and conduction losses
- Power-to-logic ground interaction and ground bounce
- Effects of the estimated PCB and package parasitics

Under the simulated conditions, the inverter achieved approximately **97.7%**
efficiency in the high-frequency Test0 case and **96.8%** efficiency in the
sinusoidal PWM Test1 case. The total simulated MOSFET losses were approximately
**37.9 W** and **50.2 W**, respectively.

The simulated maximum MOSFET drain-source voltage reached approximately
**419 V** in Test0 and **434 V** in Test1. These results identify the
switch-node voltage overshoot as an important hardware-validation point,
particularly because the simulation includes estimated rather than measured
parasitics.

The simulations also produced negative drain-source voltage excursions of
approximately **11--13 V** during commutation. This behavior is attributed to
the interaction between the commutation current, parasitic inductance, and
the MOSFET body-diode/freewheeling path, and should be verified experimentally
during double-pulse and inverter testing.

A significant ground-reference excursion was observed between `PGND` and
`LGND`, reaching approximately:

\[
V_{PGND-LGND}\approx-0.6\,\mathrm{V}\ldots+0.6\,\mathrm{V}
\]

with an average magnitude of approximately **0.2 V** under the simulated
worst-case conditions. This highlights the importance of minimizing the
common impedance between the power and logic domains. In particular, the
result reinforces the need for careful PCB grounding, short gate-drive
return paths, and adequate noise immunity at the MGD logic inputs.

Overall, the simulations indicate that the proposed HBM power-stage design
is viable as a first-pass implementation, while identifying **switch-node
overshoot, commutation transients, and PGND/LGND ground bounce** as the
primary areas requiring hardware verification.

The simulation results therefore serve as a baseline for subsequent
prototype testing and layout refinement rather than as a replacement for
physical validation.

---

## 7. Layout Considerations & Highlights

Particular attention is given to the following layout-critical aspects:

- High-frequency commutation-loop area
- Gate-drive loop area
- Switch-node copper geometry
- Local DC-link decoupling
- Current-sense layout
- Ground and reference paths
- Creepage and clearance
- Thermal paths
- EMI-sensitive interfaces

**High-Voltage Divider**

The high-voltage switch-node sensing divider is implemented as a series string of high-voltage resistors. Due to the required resistance value and the voltage stress across the divider, the resistor string is arranged in a serpentine or "snake-like" layout, with the resistor sections alternating between PCB layers. This arrangement allows the required resistance and voltage rating to be distributed across multiple components while maintaining the required creepage distance within the available PCB area.

Particular attention is given to the physical routing of the high-voltage divider, ensuring that adjacent sections of the resistor string maintain adequate creepage and clearance from other circuitry and from lower-voltage nodes.

The high-voltage divider layout therefore represents a compromise between electrical spacing, resistor voltage distribution, available PCB area, and practical component placement. The serpentine arrangement allows the divider to satisfy these requirements without requiring an excessively large dedicated PCB region.

**Gate-Drive Component Placement**

The gate resistors are placed as close as practical to the MOSFET gate terminals. Minimizing the physical distance between the gate resistor and the gate pin reduces the parasitic inductance of the gate-drive path and helps ensure that the intended gate resistance dominates the switching behavior. This reduces gate ringing and limits high-frequency voltage overshoot at the MOSFET gate.

The gate-source bleeder resistors are similarly placed close to the MOSFET gate and source terminals. This minimizes the impedance of the local gate-source discharge path and ensures that the MOSFET gate is held at a well-defined potential when the gate driver is inactive or disconnected.

The gate-driver decoupling capacitors are placed immediately adjacent to the MGD supply and ground pins. This minimizes the high-frequency supply-loop inductance and provides a low-impedance local current source for the transient current demanded by the gate driver during MOSFET switching.

For the high-side gate driver, the bootstrap capacitor is likewise placed as close as practical to the MGD bootstrap and high-side supply/reference pins. Minimizing the bootstrap loop area reduces parasitic inductance and voltage transients associated with the high-frequency charging and discharging currents of the bootstrap network.

Overall, the placement strategy keeps the gate-drive components physically close to the devices they directly serve, minimizing parasitic interconnect inductance and reducing the susceptibility of the gate-drive network to ringing, overshoot, and high-frequency electromagnetic coupling.

**Creepage**
Creepage requirements are considered throughout the PCB layout, with an average creepage distance of approximately \(3\,\mathrm{mm}\) maintained across the board for the high-voltage regions. The minimum creepage condition is localized to the TO-220 MOSFET footprints, where the package geometry and pad arrangement impose the most restrictive spacing.

![alt](Images_G0A/HBM0e1.svg)
**Attention was paid to the following critical current loops, as illustrated in the previous figure.**

**1. High-Frequency Power Loop**

The high-frequency power loop is formed by the high-frequency decoupling capacitors, the high-side MOSFET, and the low-side MOSFET. The primary current path is:

\[
+C_{HF} \rightarrow \text{High-Side FET Drain} \rightarrow \text{High-Side FET Source} \rightarrow \\[4pt]
 \text{Low-Side FET Drain} \rightarrow \text{Low-Side FET Source} \rightarrow -C_{HF}
\]

This loop carries the highest \(di/dt\) currents in the power stage and is therefore minimized in both physical area and parasitic inductance.

Polypropylene film capacitors are used for the high-frequency decoupling network due to their low ESR and low ESL, allowing them to provide a low-impedance path for the high-frequency switching current.

**2. High-Side FET Gate-Drive Loop**

The high-side gate-drive loop is kept as small as practical to minimize parasitic inductance in the gate-drive path. Minimizing the loop area reduces the voltage induced by the high \(di/dt\) gate-drive current and helps limit gate ringing, overshoot, and unwanted coupling into adjacent circuitry.

**3. Low-Side FET Gate-Drive Loop**

The low-side gate-drive loop is similarly minimized to reduce parasitic inductance and the resulting voltage transients associated with the high \(di/dt\) gate-drive current. A compact gate-drive loop helps maintain controlled \(V_{GS}\) transitions and reduces the susceptibility of the gate signal to ringing and noise.

**4. Shunt Connection**

Particular attention is given to the Kelvin connection between the current-sense shunt resistor and the shunt amplifier. The sense connections are routed independently from the high-current path so that the voltage developed across the shunt is measured with minimal influence from parasitic PCB resistance and inductance.

This reduces measurement error and minimizes the coupling of common-mode switching noise into the current-sensing circuitry.

**5. MGD COM--LGND Connection**

The connection between `MGD COM` and `LGND` is intentionally implemented through a parallel RC network. This prevents substantial high-frequency current associated with the power switching loop from flowing through the intended logic-ground reference and disturbing the defined star-grounding scheme.

At the same time, the capacitor provides a low-impedance path for PWM signal edges and other high-frequency components, maintaining a suitable high-frequency reference between `MGD COM` and `LGND` without establishing a low-impedance DC path for power-current components.

This arrangement therefore provides a compromise between maintaining the intended ground-domain topology at low frequencies and providing a controlled high-frequency return path for the gate-drive and PWM circuitry.

---

## 8. Field Tests and Validation 🛠️

[Document laboratory testing, measurements, test conditions, and
comparison against simulation.]

---

## 9. Known Issues and Limitations 🛠️

[Document known limitations of Rev. A / Gen0.]

---

## 10. Revisions

| Revision | Date | Description |
|---|---|---|
| Rev. 0 | August 2026 | Initial technical reference |