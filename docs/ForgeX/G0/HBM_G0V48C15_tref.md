---
toc: true
toc_depth: 3
export_on_save:
  prince: true
---

@import "../../forgex_doc_style.css"

![](../ForgeX.svg)

# HBM_G0V48C15 Technical Reference

> **Project:** ForgeX  
> **Generation:** Gen0  
> **Document:** HBM_G0V48C15 Technical Reference  
> **Author:** Omar Magdy
> **Revision:** Rev. 0  
> **Status:** Development  
> **Date:** September 2026

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

The **HBM_G0V48C15** is an updated Gen0 HBM implementation based on
the revised electrical requirements. The module is resized from the
original **400 V / 5 A** operating range to **48 V / 15 A**.

The updated power stage uses the **HGN036 MOSFET**, **EG2131 gate driver**,
and **ACS712-20A current sensor**.

### 1.1 Naming

`HBM_G0V48C15` follows the ForgeX module naming convention:

- `HBM` — Half-Bridge Module
- `G0`  — Generation 0
- `V48` — 48 V voltage class
- `C15` — 15 A current class

The `V48C15` designation reflects the updated electrical operating
range of the module, which is resized from the original 400 V / 5 A
design to 48 V / 15 A.

The `C15` designation should not be interpreted as an unconditional
continuous-current rating. The achievable current depends on
operating conditions including cooling, switching frequency, thermal
limits, PCB characteristics, and the applicable electrical and EMI
constraints.

### 1.2 Overview

The HBM implements a single half-bridge power stage intended to be
combined with other HBM modules through the ForgeX PMB and LVP
interfaces.

The HBM_G0V48C15 is designed around the updated electrical operating
range of **48 V / 15 A**, compared with the original 400 V / 5 A
design.

The module is designed around the principle of **electrical locality**:
the high-current switching path, gate-drive loop, local decoupling,
current sensing, and switch-node structures are kept physically close
to one another to minimize parasitic inductance and unwanted coupling.

The principal functions of the HBM are:

- 48 V half-bridge power switching
- Local MOSFET gate drive using the EG2131
- Phase-current measurement using the ACS712-20A
- Switch-node voltage measurement
- Local fault and protection handling
- Interface to the ForgeX PMB power infrastructure
- Low-voltage control interface to the ForgeX LVP

### 1.3 Design Files

The design files for HBM_G0V48C15 will be maintained in the ForgeX
repository.

The following files will be linked here once they are available:

- **PCB & Schematic:** 🛠️
- **Simulation:** 🛠️
- **Manufacturing files:** 🛠️
---

## 2. Interfaces & I/O

> **Note:** The interface diagram is currently under development and will be updated once the final design is completed.

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

- 48 V DC-link operation
- 15 A class power handling
- Efficient switching operation from 8–20 kHz with manageable conduction and switching losses
- Controlled switch-node ringing and voltage overshoot within component and system limits
- Current measurement bandwidth of at least 40 kHz
- Robust operation in the presence of switching noise and transients
- Controlled conducted and radiated EMI to minimize interference with other system components

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

The selected MOSFET for the HBM power stage is the `HGN036N08S`.
The device was selected based on its electrical characteristics,
high-current capability, low conduction resistance, high-speed
switching performance, package construction, and suitability for the
intended 48 V / 15 A switching conditions.

**Datasheet:** [HGN036N08S](https://www.alldatasheet.net/view_datasheet.jsp?Searchword=HGN036)

**Selection rationale:**

* **80 V drain-source rating:** The device has an 80 V maximum `VDS`
  rating, providing voltage margin above the nominal 48 V DC-link
  voltage. This margin provides tolerance to switching-node
  overshoot and transient voltage spikes.
* **High current capability:** The HGN036N08S is specified with a
  continuous drain current of up to 60 A under the package-limited
  condition at `TC = 25°C`, providing substantial current capability
  relative to the HBM's 15 A class operating current.
* **Low `RDS(on)`:** The device has a typical `RDS(on)` of 3.0 mΩ at
  `VGS = 10 V` and `ID = 20 A`. The low on-state resistance helps
  reduce conduction losses during normal operation.
* **Low gate charge:** The total gate charge `QG` is 61 nC, while the
  gate-to-drain (Miller) charge `QGD` is 18 nC. These parameters are
  considered in the gate-drive and switching-speed calculations.
* **High-speed switching:** The datasheet specifies the device for
  high-speed power switching and hard-switching applications,
  making it suitable for the HBM's intended switching-frequency
  range.
* **Enhanced body-diode dv/dt capability:** The device includes
  enhanced body-diode dv/dt capability, which is beneficial in the
  switching environment of a half-bridge power stage.
* **Package:** The MOSFET is provided in a compact DFN5×6 package,
  supporting a physically localized power stage and short
  high-current switching paths.
  
### 5.2 Gate Drive

The selected gate-driver IC for the HBM is the `EG2131` from EG Micro.

**Datasheet:** [EG2131](https://www.lcsc.com/datasheet/C193777.pdf)

**Selection rationale:**

* **Local availability and cost:** The device is readily available from local suppliers at a relatively low unit cost, making it practical for prototyping, production, and replacement.
* **300 V high-side operating capability:** The high-side floating section is rated for operation up to **300 V**, providing sufficient voltage margin for the HBM's nominal **48 V DC-link**.
* **High gate-drive current:** The driver provides up to **1 A source current** and **1.5 A sink current**, providing sufficient drive capability for the selected MOSFET at the intended switching frequencies.
* **Integrated interlock and deadtime:** The device incorporates half-bridge interlock logic and internal deadtime generation, with a typical deadtime of approximately **250 ns**. This provides protection against simultaneous turn-on of the high-side and low-side MOSFETs.
* **Bootstrap high-side drive:** The high-side driver uses a floating bootstrap supply to drive the high-side MOSFET. The bootstrap supply is implemented using an external bootstrap diode and capacitor, eliminating the need for a separate isolated high-side gate-drive supply and simplifying the gate-drive implementation.

### 5.3 External Components

The external components of the gate-drive circuit were selected based on the required switching speed, gate-drive current, bootstrap supply requirements, and supply decoupling.

### 5.3.1 Gate Resistor

The external gate resistor was selected to establish the initial
switching-speed target while providing a practical compromise between
switching losses, switch-node `dv/dt`, voltage overshoot, ringing, and
electromagnetic interference.

For the HGN036N08S, the datasheet specifies the switching-time
characteristics using an external gate resistance of:

$$
R_{G,EXT}=10\,\Omega
$$

under the test conditions:

$$
V_{DD}=40\,V,\qquad I_D=20\,A,\qquad V_{GS}=10\,V
$$

The same datasheet specifies a total gate charge of:

$$
Q_G=61\,nC
$$

and a gate-to-drain (Miller) charge of:

$$
Q_{GD}=18\,nC
$$

The 10 Ω value is therefore used as the initial external gate-resistor
value for the HBM design. The final value shall be verified through
switching simulation and hardware measurements.

**First-Order Switching Loss Estimate**

For the HBM operating point, a first-order estimate of the voltage-current
overlap switching loss of a single MOSFET is:

$$
P_{SW}
\approx
\frac{1}{2}V_{DS}I_D(t_{on}+t_{off})f_{SW}
$$

For a 48 V DC-link, 15 A operating current, and 20 kHz switching
frequency, using an initial target of approximately 100 ns turn-on and
80 ns turn-off:

$$
P_{SW}
\approx
\frac{1}{2}
\times48
\times15
\times(100+80)
\times10^{-9}
\times20\times10^3
$$

$$
P_{SW}\approx1.296\,W
$$

This is a first-order estimate of the voltage-current overlap loss only.
It does not include output-capacitance energy, body-diode reverse-recovery
losses, gate-drive losses, or additional losses caused by switch-node
ringing.

**Gate Current and Gate Resistor**

The gate current required during the Miller transition can be estimated
from the MOSFET gate-to-drain charge:

$$
I_G\approx\frac{Q_{GD}}{t_{Miller}}
$$

For the selected HGN036N08S:

$$
Q_{GD}=18\,nC
$$

**Turn-On**

For an initial target Miller transition time of approximately 100 ns:

$$
I_{G,on}
=
\frac{Q_{GD}}{t_{on}}
$$

$$
I_{G,on}
=
\frac{18\,nC}{100\,ns}
=
180\,mA
$$

The EG2131 provides a specified gate-drive source current capability
$I_{O+}$ of approximately 1.0 A. Therefore, the calculated 180 mA Miller current is
well within the driver's source-current capability.

**Turn-Off**

For an initial target turn-off transition of approximately 80 ns:

$$
I_{G,off}
=
\frac{Q_{GD}}{t_{off}}
$$

$$
I_{G,off}
=
\frac{18\,nC}{80\,ns}
=
225\,mA
$$

The EG2131 provides a specified gate-drive sink current capability
$I_{O-}$ of approximately 1.5 A. Therefore, the calculated 225 mA Miller current is
also well within the driver's sink-current capability.

The gate-current calculations confirm that the selected switching-speed
targets do not require gate currents approaching the EG2131's specified
source or sink capability.

**Gate Resistor Selection**

The HGN036N08S datasheet uses a 10 Ω external gate resistance for its
specified switching-time test condition. This value is therefore adopted
as the initial external gate-resistor value:

$$
\boxed{R_{GateExternal}=10\,\Omega}
$$

The resistor provides additional impedance in the gate-drive loop,
limiting the peak gate current and reducing the tendency for excessive
ringing and high switch-node `dv/dt`.

The actual gate-current waveform is determined by the EG2131 output
stage, MOSFET internal gate resistance, Miller plateau voltage, external
gate resistance, and PCB parasitic inductance. Since the EG2131
datasheet specifies the driver current capability (1.0 A source / 1.5 A sink) but does not provide
a directly equivalent fixed output resistance for use in a simple
resistive calculation, the final resistor value is not derived from an
assumed driver resistance.

The 10 Ω value is therefore treated as the initial design value based
on the HGN036N08S datasheet switching test condition. Separate turn-on
and turn-off resistors may be introduced later if measurements indicate
that asymmetric switching control is required.

**`dv/dt` Constraints**

The selected switching speed shall be evaluated against the principal
`dv/dt` constraints associated with the MOSFET, gate driver, and
half-bridge configuration.

**Miller-Induced False Turn-On**

When the complementary MOSFET switches, the switch-node `dv/dt` couples
through the gate-drain capacitance of the MOSFET that is in the OFF state.

The resulting Miller current can be approximated by:

$$
I_{Miller}
=
C_{GD}(V_{DS})
\frac{dV_{DS}}{dt}
$$

The actual false-turn-on behavior depends on the nonlinear
$C_{GD}(V_{DS})$ characteristic, MOSFET threshold voltage, gate-loop
impedance, temperature, and PCB parasitic inductances.

The HGN036N08S datasheet specifies enhanced body-diode `dv/dt`
capability as a device feature. The intended switch-node slew rate shall
nevertheless be verified experimentally to ensure adequate margin
against false turn-on and excessive ringing.

**Gate-Driver `dv/dt` Capability**

The EG2131 is specified as a half-bridge high-side/low-side gate driver
with a high-side floating supply capability of up to 300 V and gate-drive
output capability of approximately 1.0 A source and 1.5 A sink.

The EG2131 also includes internal dead-time control with a specified
typical dead time of approximately 250 ns ($DT_{typ}=250\,ns$).

No separate numerical `dv/dt` immunity limit is assumed here because
such a value has not been established from the selected EG2131
datasheet data used for this design.

**`di/dt` and Parasitic-Inductance Voltage**

The current slew rate through parasitic inductance generates an
additional voltage according to:

$$
V_L=L_{par}\frac{di}{dt}
$$

For a 15 A current transition occurring over approximately 100 ns:

$$
\frac{di}{dt}
\approx
\frac{15\,A}{100\,ns}
=
0.15\,A/ns
$$

For an illustrative switching-loop inductance of 20 nH:

$$
V_{L,Power}
\approx
20\,nH\times0.15\,A/ns
\approx3.0\,V
$$

If a source inductance of 7 nH is considered:

$$
V_{L,Source}
=
7\,nH\times0.15\,A/ns
\approx1.05\,V
$$

The combined first-order inductive voltage contribution is therefore:

$$
\boxed{
V_{L,Total}
\approx
3.0\,V+1.05\,V
\approx4.05\,V
}
$$

These inductance values are illustrative design assumptions and shall be
replaced by extracted or measured PCB parasitic values when the final
layout is available.

The calculated inductive voltage represents only the voltage generated by
the assumed current slew. It does not account for resonant ringing,
parasitic capacitances, diode reverse recovery, or other transient
mechanisms.

The final gate-resistor value and switching performance shall therefore be
validated through simulation and hardware testing under the target
48 V / 15 A operating conditions.

#### 5.3.2 Bootstrap Capacitor

The bootstrap capacitor provides the local energy reservoir and low-impedance current path required to drive the high-side MOSFET. In the `EG2131` implementation, the high-side floating supply is generated using an external bootstrap diode and bootstrap capacitor connected between `VB` and `VS`. During the low-side conduction interval, the bootstrap capacitor is recharged from the `VCC` supply. When the high-side MOSFET is commanded on, the stored charge provides the floating supply required by the high-side gate driver.

The bootstrap capacitor must therefore be sufficiently large to limit the voltage drop caused by MOSFET gate charge and the additional charge consumed by the gate-driver circuitry.

A first-order estimate can be obtained from the MOSFET total gate charge:

$$
\Delta V_{BOOT} = \frac{\Delta Q}{C_{BOOT}}
$$

For the selected `HGN036N08S`, the total gate charge is approximately:

$$
Q_G \approx 61\,\mathrm{nC}
$$

Using a preliminary target gate-drive voltage of:

$$
V_{GS} \approx 12\,\mathrm{V}
$$

the equivalent charge-based gate capacitance can be estimated as:

$$
C_G \approx \frac{Q_G}{V_{GS}}
$$

Therefore:

$$
C_G
\approx
\frac{61\,\mathrm{nC}}{12\,\mathrm{V}}
\approx
5.08\,\mathrm{nF}
$$

Using a simple 10× design rule gives:

$$
C_{BOOT} \geq 10C_G
$$

and therefore:

$$
C_{BOOT} \geq 50.8\,\mathrm{nF}
$$

This value is only a first-order lower-bound estimate. The actual bootstrap capacitor must also account for the gate-driver current consumption, MOSFET gate charge, bootstrap-diode voltage drop, capacitor tolerance, temperature and DC-bias effects, maximum high-side on-time, and the allowable bootstrap-voltage ripple.

A **1 µF** bootstrap capacitor was selected as a preliminary design value for the HBM.

**Justification:**

The larger capacitor was selected to provide substantial charge reserve and reduce bootstrap-voltage variation during high-side operation rather than operating close to the theoretical minimum capacitance.

Considering only the MOSFET gate-charge contribution, the voltage drop associated with one complete gate-charge event is:

$$
\Delta V_{BOOT}
\approx
\frac{61\,\mathrm{nC}}{1\,\mathrm{\mu F}}
\approx
61\,\mathrm{mV}
$$

This represents only a small fraction of the available bootstrap supply voltage. The actual bootstrap-voltage reduction will be higher because the high-side driver also consumes charge during operation; therefore, the 61 mV value should be treated as a gate-charge-only estimate rather than the total expected bootstrap droop.

The selected capacitance also provides a substantial margin relative to the first-order 10× estimate:

$$
\frac{1\,\mathrm{\mu F}}{50.8\,\mathrm{nF}}
\approx
19.7
$$

Thus, the selected capacitor is approximately 20 times larger than the calculated 10× lower-bound value.

The principal trade-off of the larger capacitance is the increased charge required during the initial bootstrap charging interval. The actual charging behavior depends on the external bootstrap diode, its forward voltage and dynamic resistance, the `VCC` supply, PCB resistance, and the capacitor characteristics. Consequently, no fixed bootstrap charging-time value is assumed without the final charging-path parameters.

The `EG2131` datasheet specifies an external bootstrap diode and bootstrap capacitor for the high-side floating supply. The final bootstrap capacitor and diode selection should therefore be verified together with the complete switching waveform and the maximum intended high-side on-time.

The selected **1 µF** value should consequently be understood as a **preliminary hold-up and robustness choice**, rather than as a datasheet-mandated minimum value. Final validation should confirm the bootstrap voltage remains within the required operating range under the maximum intended duty cycle, switching frequency, temperature, and transient operating conditions.

#### 5.3.3 VCC Decoupling Capacitor

The gate-driver supply requires local decoupling to provide the high-frequency current demanded by the gate-drive output stage and to minimize voltage sag, supply-loop inductance, and voltage transients during switching transitions.

The `EG2131` datasheet specifies a high-frequency **0.1 µF bypass capacitor** connected between `VCC` and `GND` to reduce high-frequency noise at the driver supply input. The typical application circuit additionally shows a **10 µF** capacitor connected across the VCC supply.

For the selected HBM implementation, a **10 µF** local VCC decoupling capacitor is therefore selected, together with a **0.1 µF high-frequency ceramic bypass capacitor** placed in parallel.

The 10 µF capacitor provides local bulk energy storage for the gate-driver supply, while the 0.1 µF ceramic capacitor provides a low-impedance path for the high-frequency current components generated during gate-drive transitions.

The selected VCC decoupling network is therefore:

$$
\boxed{C_{VCC}=10\,\mathrm{\mu F}}
$$

with:

$$
\boxed{C_{HF}=0.1\,\mathrm{\mu F}}
$$

The capacitors should be placed directly adjacent to the `EG2131` `VCC` and `GND` pins, with short and wide PCB connections to minimize the associated loop area and parasitic inductance.

The `EG2131` VCC supply operates within the specified range of:

$$
11\,\mathrm{V}\leq V_{CC}\leq20\,\mathrm{V}
$$

and the selected decoupling network should therefore be rated appropriately for the actual VCC supply voltage and expected operating conditions.

The selected VCC decoupling network provides both local energy storage and high-frequency bypassing, helping to maintain a stable gate-driver supply and reduce supply-voltage transients during high-current switching transitions.

#### 5.3.4 RC Snubber

A first-pass RC snubber value was estimated from the effective switching-loop 
inductance ($L_0 = 20\,\mathrm{nH}$) and the MOSFET parasitic output capacitance ($C_{oss} \approx 565\,\mathrm{pF}$). 

The initial capacitance is chosen as approximately four times $C_{oss}$ to effectively damp the resonance:

$$
C_{snub} \approx 4 \times C_{oss} \approx 4 \times 565\,\mathrm{pF} \approx 2.26\,\mathrm{nF}
$$

The damping resistor is matched to the characteristic impedance of the parasitic LC tank formed by $L_0$ and $C_{oss}$:

$$
R_{snub} \approx \sqrt{\frac{L_0}{C_{oss}}} = \sqrt{\frac{20\,\mathrm{nH}}{565\,\mathrm{pF}}} \approx 5.95\,\Omega
$$

Using these parameters, the initial RC snubber network values are selected as:

$$
\boxed{C_{snub} = 2.2\,\mathrm{nF}}
$$

$$
\boxed{R_{snub} = 6.2\,\Omega}
$$

where $L_0 = 20\,\mathrm{nH}$ represents the estimated high-frequency switching-loop inductance, including relevant MOSFET package and interconnect inductances. Standard nominal E24 resistor and capacitor values ($2.2\,\mathrm{nF}$ and $6.2\,\Omega$) were selected for practical implementation.

The average power dissipation in the snubber resistor can be estimated as:

$$
P_{snub} \approx C_{snub} \times V_{DS}^2 \times f_{SW} = 2.2\,\mathrm{nF} \times (48\,\mathrm{V})^2 \times 20\,\mathrm{kHz} \approx 0.101\,\mathrm{W}
$$

These values provide an initial damping network for the switch-node LC resonance. The final snubber values and resistor power ratings shall be verified experimentally or through switching-waveform simulation by evaluating the resulting overshoot, ringing, switching losses, and snubber power dissipation under full load conditions.

#### 5.4 Current Sensing

Since galvanic isolation between the power and logic domains provides inherent noise immunity and protects the microcontroller, a Hall-effect-based current sensor is employed for phase-current monitoring.

The **ACS712** fully integrated Hall-effect current sensor IC from Allegro MicroSystems is selected for this function.

**Datasheet:** [ACS712 Datasheet](https://www.sparkfun.com/datasheets/Breakouts/ACS712-datasheet.pdf)

**Selection Rationale:**

* **Galvanic Isolation:** Integrated copper conduction path provides up to $2.1\,\mathrm{kV_{RMS}}$ galvanic isolation, fully decoupling the high-power switching node from the low-voltage control domain.
* **Low Internal Resistance:** The internal conductor resistance is typically $1.2\,\mathrm{m\Omega}$, minimizing conduction losses and thermal dissipation compared to traditional shunt topologies.
* **Bidirectional Sensing Capability:** Naturally biased at $V_{CC} / 2$, allowing seamless measurement of both positive and negative AC/phase current swings.
* **Precise Proportional Output:** Generates an analog voltage output directly proportional to the AC or DC sensed current.

**Sensitivity and Output Characteristics**

The ACS712 features an internal zero-current output voltage set to half of its supply voltage:

$$
V_{OUT(Q)} = \frac{V_{CC}}{2}
$$

Operating from a $5.0\,\mathrm{V}$ rail ($V_{CC} = 5.0\,\mathrm{V}$), the quiescent output voltage at $0\,\mathrm{A}$ is:

$$
V_{bias} = 2.5\,\mathrm{V}
$$

For the target operating conditions, the **ACS712-20A** variant is selected. The nominal sensitivity for this model is:

$$
\text{Sensitivity} = 100\,\mathrm{mV/A}
$$

The overall current-to-voltage transfer function is given by:

$$
V_{OUT} = \left(I \times \text{Sensitivity}\right) + V_{bias}
$$

$$
V_{OUT} = \left(I \times 0.100\,\mathrm{V/A}\right) + 2.5\,\mathrm{V}
$$

Thus, the current-sensing path sensitivity is:

$$
\boxed{\text{Sensitivity} = 0.100\,\mathrm{V/A}}
$$

**Measurement Range and ADC Interface**

For the ACS712-20A, the theoretical bidirectional measurement range is $\pm 20\,\mathrm{A}$. Over the full $5.0\,\mathrm{V}$ supply rail, the output voltage swing is:

$$
V_{OUT,max} = +20\,\mathrm{A} \times 0.100\,\mathrm{V/A} + 2.5\,\mathrm{V} = 4.5\,\mathrm{V}
$$

$$
V_{OUT,min} = -20\,\mathrm{A} \times 0.100\,\mathrm{V/A} + 2.5\,\mathrm{V} = 0.5\,\mathrm{V}
$$

$$
\boxed{I_{range} = \pm 20\,\mathrm{A}}
$$

**ADC Attenuation Network ($3.3\,\mathrm{V}$ Domain)**

Because the ACS712 produces an output up to $4.5\,\mathrm{V}$ (exceeding the $3.3\,\mathrm{V}$ ADC limit), a precision resistor divider is placed at the output to scale the voltage swing down to a safe range ($0.33\,\mathrm{V} \to 2.97\,\mathrm{V}$):

$$
\text{Scale Factor} = \frac{R_2}{R_1 + R_2} = \frac{20\,\mathrm{k\Omega}}{10\,\mathrm{k\Omega} + 20\,\mathrm{k\Omega}} = \frac{2}{3}
$$

$$
V_{ADC} = V_{OUT} \times \frac{2}{3}
$$

This maps the zero-current ($0\,\mathrm{A}$) point from $2.5\,\mathrm{V}$ to **$1.667\,\mathrm{V}$**, fitting comfortably within the $0 \to 3.3\,\mathrm{V}$ ADC voltage rail.

**Internal Conductor Power Dissipation**

Due to the extremely low internal primary conductor resistance ($R_{primary} \approx 1.2\,\mathrm{m\Omega}$), continuous power loss is drastically reduced compared to external shunts:

$$
P_{sensor} = I_{RMS}^2 \times R_{primary}
$$

At the nominal $15\,\mathrm{A}$ peak operating current ($I_{RMS} \approx 10.61\,\mathrm{A_{RMS}}$):

$$
P_{sensor} = (10.61\,\mathrm{A})^2 \times 1.2\,\mathrm{m\Omega} \approx 0.135\,\mathrm{W}
$$

$$
\boxed{P_{sensor} \approx 135\,\mathrm{mW}}
$$

This minimal power dissipation eliminates thermal derating issues and reduces overall PCB thermal stress.

**Noise Filtering and Bandwidth Adjustment**

The ACS712 includes an internal $80\,\mathrm{kHz}$ bandwidth limit. An external filter capacitor ($C_F$) connected to the `FILTER` pin sets the overall system bandwidth and mitigates high-frequency switching noise:

$$
f_{-3\mathrm{dB}} = \frac{1}{2\pi \times 20\,\mathrm{k\Omega} \times C_F}
$$

A $10\,\mathrm{nF}$ ceramic capacitor ($C_F = 10\,\mathrm{nF}$) is selected, establishing a cutoff frequency of approximately:

$$
f_{-3\mathrm{dB}} \approx 796\,\mathrm{Hz}
$$

This bandwidth configuration provides effective filtering of $20\,\mathrm{kHz}$ PWM switching noise while maintaining adequate response speed for phase current monitoring and feedback control.

### 5.5 Voltage Sensing

For the `HBM_G0V48C15`, galvanic isolation is not enforced between the power and logic domains, and `PGND` and `LGND` are therefore required to be connected at a defined point within the system. This permits the switch-node and DC-link voltages to be sensed directly with respect to `LGND` using a high-voltage resistive divider.

The divider ratio is selected such that the nominal $48\,\mathrm{V}$ DC-link operating voltage, including maximum transient overvoltage events up to $60\,\mathrm{V}$, is mapped into the valid $0 \to 3.3\,\mathrm{V}$ range of the analog sensing circuitry:

$$
V_{signal} = V_{sw} \times \frac{R_2}{R_1 + R_2}
$$

Using a lower resistor $R_2 = 10\,\mathrm{k\Omega}$ and an upper resistor network $R_1 = 180\,\mathrm{k\Omega}$ ($R_{total} = 190\,\mathrm{k\Omega}$), the voltage divider transfer function is:

$$
V_{signal} = V_{sw} \times \frac{10\,\mathrm{k\Omega}}{180\,\mathrm{k\Omega} + 10\,\mathrm{k\Omega}} = V_{sw} \times \frac{1}{19}
$$

This gives the following nominal full-scale mapping:

$$
60\,\mathrm{V} \rightarrow 3.158\,\mathrm{V}
$$

$$
48\,\mathrm{V} \rightarrow 2.526\,\mathrm{V}
$$

$$
\boxed{\text{Scaling Factor} = 0.0526\,\mathrm{V/V}}
$$

The resulting scaling makes effective use of the available ADC input range while retaining a small safety margin below the $3.3\,\mathrm{V}$ rail to prevent clipping during voltage spikes or inductive ringing. The divider upper leg $R_1$ is implemented as a series string of resistors to ensure that the voltage stress across each individual component remains within its rated working voltage, while maintaining the required creepage and clearance distances across the high-voltage portion of the PCB layout.

The power dissipated by the divider under the nominal $48\,\mathrm{V}$ DC-link condition is approximately:

$$
P_{divider} = \frac{(48\,\mathrm{V})^2}{180\,\mathrm{k\Omega} + 10\,\mathrm{k\Omega}} \approx 0.0121\,\mathrm{W}
$$

$$
\boxed{P_{divider} \approx 12.1\,\mathrm{mW}}
$$

This dissipation is distributed across the series resistor string rather than concentrated in a single component, reducing the thermal and voltage stress on each individual resistor.

The switch-node measurement is particularly useful in operating conditions where the half-bridge is in a high-impedance state, with both MOSFETs turned off. In this condition, the switch-node voltage is no longer actively driven by either device and can provide useful information about the external load, motor phase Back-EMF, or commutation state. This makes the sensing path applicable to control and diagnostic functions such as high-impedance phase-voltage measurement and zero-crossing detection in motor-control applications.

### 5.6 References

* [TI — Bootstrap Circuitry Selection for Half-Bridge Configurations](https://www.ti.com/lit/an/slua887a/slua887a.pdf)
* [Infineon — Using Monolithic High-Voltage Gate Drivers](https://www.infineon.com/row/public/documents/24/42/infineon-using-monolithic-high-voltage-gate-drivers-applicationnotes-en.pdf)
* [Seminar 1400 Topic 2 APDX Estimating MOSFET Parameters from the Data Sheet](https://www.ti.com/lit/ml/slup170/slup170.pdf?ts=1786803369734)

---
<div style="page-break-after: always;"></div>

Note: This section is currently under development.
 Simulation models and hardware validation results are being updated for the latest module revision 
 and will be finalized upon complete testing.

<div style="page-break-after: always;"></div>

