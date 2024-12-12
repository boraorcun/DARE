---
title: 'DARE: A MATLAB code package for Design and Analysis of Ramjet/scramjet Engines'
tags:
  - Matlab
  - Reduced order modeling
  - High-speed propulsion
  - Ramjet
  - Scramjet
  - Detailed chemistry 
 
authors:
  - name: Bore O. Cakir
    orcid: 0000-0002-3577-4730
    equal-contrib: true
    affiliation: "1, 2" # (Multiple affiliations must be quoted)
  - name: Ali Can Ispir
    orcid: 0000-0002-2396-6647
    equal-contrib: true # (This is how you can denote equal contributions between multiple authors)
    affiliation: 3
affiliations:
 - name: Department of Energy Sciences, Lund University, Sweden 
   index: 1
 - name: Department of Turbomachinery and Propulsion, von Karman Insitute for Fluid Dynamics, Belgium
   index: 2
 - name: Department of Mechanical Engineering, Eindhoven University of Technology, the Netherlands
   index: 3
date: 13 August 2017
bibliography: paper.bib

---

# Summary

The advancement of supersonic civil aviation, with a focus on improving both technical and environmental sustainability, requires a holistic approach to the design and performance assessment of supersonic aircraft. These designs must meet the demands of high-speed flight while also being adaptable to varying external conditions throughout their missions, necessitating optimization of aerodynamic and propulsion systems across different operating conditions `[kuchemann@2012]`. Therefore, configuring, optimizing, and analyzing a high-speed propulsion system is crucial to the development of supersonic and hypersonic aircraft. When considering propulsion system architectures that align with the mission requirements of high-speed aircraft, ramjet engines present notable advantages over rocket engines, as they eliminate the need for onboard oxidizer storage or rotating components. Although ramjets are structurally simpler than turbo-based aero-engines, their internal flow dynamics are intricate and require careful study to ensure stability and optimal performance `[murthy@2001]`. As such, conceptual design methods using zero- and one-dimensional approaches provide a cost-effective alternative to detailed numerical simulations. These methods enable the analysis of design parameters and operational variables for key components, as well as the evaluation of propulsion performance metrics like thrust, specific impulse, and fuel consumption.

# Statement of need

In this regard, reduced order models for high-speed propulsion systems, including ramjet and scramjet engine configurations, have been developed and tested since the mid-1960s. Early low-fidelity models analyzed how fuel injection and mixing affect the ramjet/scramjet cycle by simulating flow through intake contours using a two-shock approach \cite{bauer1966}. These models examined critical conditions in the combustion chamber, such as pre-ignition states, fuel mixing, ignition methods, and combustor length reduction, while exploring propulsion system characteristics at various altitudes and speeds. To enhance performance and reduce weight of ramjet engines, a numerical approach combining finite-difference solutions with a well-stirred reactor model and finite-rate chemistry was proposed, incorporating a shear layer model to account for viscous effects \cite{harsha1978, edelman1981}. Later studies introduced 1D models with Eulerian-Lagrangian coupling to examine both stable and unstable combustion modes and their impacts on cycle performance \cite{bhatia1990} and modelling thrust losses due to incomplete fuel burning and entropy losses from irreversibility using aerothermodynamics principles \cite{riggins1995}. In subsequent research, O'Brien and colleagues proposed a one-dimensional model for high-speed propulsion flow paths, incorporating finite-rate chemistry to examine how fuel mixing and ignition timescales affect various engine operating conditions \cite{brien2001}. Other studies developed physics-based models to combine low-fidelity propulsion computations with structural integrity considerations for air-breathing hypersonic engines, estimating propulsive performance under different aeroelastic modes \cite{chavez1994, bolender2007}. Similarly, Birzer and Doolan developed a model for a hydrogen-fueled scramjet combustor using a set of one-dimensional ordinary differential equations, validating their approach with experimental data from the Hyshot-II cases \cite{birzer2009quasi}. However, these models lacked adequate combustion modeling, failing to consider the aerothermochemical effects of gas mixing and burning in the combustion chamber. In order to resolve these issues, Torrez et al. created a reduced-order engine model for high-speed propulsion systems, simulating mixing and combustion in ramjet and scramjet engines \cite{torrez2011}. The authors improved their MASIV numerical tool by coupling it with the Shapiro method to predict the thermal choking position, which is a mathematical singularity in the ramjet engine duct \cite{torrez2013new}. Additionally, Tian et al. introduced a quasi-1D strength-adaptable shock approach to estimate pre-combustion conditions, modeling the interactions between flow development in the isolator and the combustion modes of dual-mode scramjets or ramjets \cite{tian2014}. 

Although there are numerous low-fidelity design and analysis studies aimed at accurately characterizing the performance specifications of ramjet engines, most focus on individual components of the propulsion system rather than a comprehensive methodology. Few studies consider the combined influence of flight conditions and design parameters throughout the entire propulsive flow path. Therefore, this study integrates individual design and analysis approaches for high-speed propulsion components to develop a holistic, low-fidelity design method for cost-efficient characterization of the ramjet engine design space. Accordingly, `RASDAS` is developed.

# Research applications

- acta 2022
- hisst 2022 I: ramjet, hisst 2022 II: scramjet
- scitech 2023
- acta 2024
- astec 2024 

# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"

# Acknowledgements

This project has received funding from the European Union's Horizon 2020 research and innovation programme, MORE \& LESS (MDO and REgulations for Low-boom and Environmentally Sustainable Supersonic aviation) project under grant agreement No 101006856. 

# References
