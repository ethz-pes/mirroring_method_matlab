# Magnetic Mirroring Method with MATLAB

![license - BSD](https://img.shields.io/badge/license-BSD-green)
![language - MATLAB](https://img.shields.io/badge/language-MATLAB-blue)
![category - power electronics](https://img.shields.io/badge/category-power%20electronics-lightgrey)
![status - unmaintained](https://img.shields.io/badge/status-unmaintained-red)

This **MATLAB** tool is a complete implementation of the **magnetic mirroring method** also known as **method of images**.
The complete implementation is **object oriented** and includes several **examples**.
The tool be used to compute the magnetic properties of different components, e.g., **inductors, transformers, and litz wires**.

The following properties can be computed:
* **Magnetic field pattern** (vector or norm)
* **Inductance matrix** between the conductors
* **Energy** for a given excitation
 
The following configurations can be computed:
* Conductors in free space (no magnetic boundary)
* Conductors surrounded by a single magnetic boundary
* Conductors surrounded by two parallel magnetic boundaries
* Conductors surrounded by a box of four magnetic boundaries

The following additional features and constraints exist:
* The magnetic boundary can feature finite permeability
* The conductors are accepted to be round with an uniform current density
* The conductors are accepted to be round with an uniform current density.
* The radius and the position of the different conductors is arbitrary
* Line conductors (without zero radius) are accepted
* No HF effects (skin or proximity) are considered (can be added in post-processing)

## Examples

The following examples are included:
* [test_inductor.m](test_inductor.m) - Simulation of an inductor with air gaps
* [test_transformer.m](test_transformer.m) - Simulation of a transformer
* [test_parallel_wire.m](test_parallel_wire.m) - Current sharing problem for parallel wires

### Inductor Field

<p float="middle">
    <img src="readme_img/inductor_conductor.png" width="250">
    <img src="readme_img/inductor_field.png" width="250">
    <img src="readme_img/inductor_matrix.png" width="250">
</p>

### Transformer Field

<p float="middle">
    <img src="readme_img/transformer_conductor.png" width="250">
    <img src="readme_img/transformer_field.png" width="250">
    <img src="readme_img/transformer_matrix.png" width="250">
</p>

### Litz Wire Current Sharing

<p float="middle">
    <img src="readme_img/litz_field.png" width="250">
    <img src="readme_img/litz_matrix.png" width="250">
    <img src="readme_img/litz_sharing.png" width="250">
</p>

## Compatibility

The tool is tested with the following MATLAB setup:
* Tested with MATLAB R2018b / 2019a / 2024b
* No toolboxes are required.
* Compatibility with GNU Octave not tested but probably easy to achieve.

## References

The following references explain the theory and applications of the mirroring method:
* Muehlethaler, J. / Modeling and Multi-Objective Optimization of Inductive Power Components / 2012
* Ferreira, J.A. / Electromagnetic Modelling of Power Electronic Converters / 1989
* Bossche, A. and Valchev, V. / Inductors and Transformers for Power Electronics / 2005.
* Binns, K. and Lawrenson, P. / Analysis and Computation of Electric and Magnetic Field Problems / 1973

## Author

* **Thomas Guillod, ETH Zurich, Power Electronic Systems Laboratory** - [GitHub Profile](https://github.com/otvam)

## License

* This project is licensed under the **BSD License**, see [LICENSE.md](LICENSE.md).
* This project is copyrighted by: (c) 2016-2025, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod.
