---
toc: true
toc_depth: 3
export_on_save:
  prince: true
---

@import "../../forgex_doc_style.css"

![](../ForgeX.svg)

# PSU_G0P20N Technical Reference

> **Project:** ForgeX  
> **Generation:** Gen0
> **Document:** PSU_G0P20N Technical Reference  
> **Author:** Omar Magdy  
> **Revision:** Rev. 0  
> **Status:** Development  
> **Date:** August 2026

<div style="page-break-after: always;"></div>

## Table of Contents
[TOC]

<div style="page-break-after: always;"></div>

## 1. Introduction



---

### 1.1 Naming

`PSU_G0P20N` follows the ForgeX module naming convention:


### 1.2 Overview


---

## 2. Interfaces & I/O


### 2.1 Power Interface

### 2.2 Low-Voltage Interface

### 2.3 Non Isolated Tie Interface

---

## 3. Design Requirements

- 400 V DC-link operation


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

### 5.1 Off-line Switcher

### 5.2 Flyback transformer

### 5.3 RCD Clamp

### 5.4 Feedback & Compensation

---
## 6. Layout Considerations & Highlights

---

## 7. Design Files

The complete hardware design files for this module are maintained in the ForgeX repository:

**revA:**
- [PCB & Schematic](https://github.com/Omar-Magdy0/ForgeDriveHW/tree/main/ForgeX/PSU_G0P20N/revA)
- [Simulation](https://github.com/Omar-Magdy0/ForgeDriveHW/tree/main/ForgeX/PSU_G0P20N/revA/Doc/simulation)
- **Manufacturing files:** 🛠️

## 8. Simulation

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

**Switching Model**


**Small Signal Model**



---

### 8.5 Digest and Conclusion

## 9. Field Tests and Validation 🛠️

[Document laboratory testing, measurements, test conditions, and
comparison against simulation.]

---

## 10. Known Issues and Limitations 🛠️

[Document known limitations of Rev. A / Gen0.]

---

## 11. Revisions

| Revision | Date | Description |
|---|---|---|
| Rev. 0 | August 2026 | Initial technical reference |