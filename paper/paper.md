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

The advancement of supersonic civil aviation, with a focus on improving both technical and environmental sustainability, requires a holistic approach to the design and performance assessment of supersonic aircraft. These designs must meet the demands of high-speed flight while also being adaptable to varying external conditions throughout their missions, necessitating optimization of aerodynamic and propulsion systems across different operating conditions [@kuchemann2012]. Therefore, configuring, optimizing, and analyzing a high-speed propulsion system is crucial to the development of supersonic and hypersonic aircraft. When considering propulsion system architectures that align with the mission requirements of high-speed aircraft, ramjet engines present notable advantages over rocket engines, as they eliminate the need for onboard oxidizer storage or rotating components. Although ramjets are structurally simpler than turbo-based aero-engines, their internal flow dynamics are intricate and require careful study to ensure stability and optimal performance [@murthy2001]. As such, conceptual design methods using zero- and one-dimensional approaches provide a cost-effective alternative to detailed numerical simulations. These methods enable the analysis of design parameters and operational variables for key components, as well as the evaluation of propulsion performance metrics like thrust, specific impulse, and fuel consumption.

# Statement of need

Since the 1960s, reduced-order models for high-speed propulsion systems, including ramjet and scramjet engines, have been developed and tested. Early models focused on fuel injection and mixing effects, simulating flow through intake contours with a two-shock approach \cite{bauer1966}. These studies addressed key combustion chamber conditions like pre-ignition states, fuel mixing, and ignition methods, and explored propulsion characteristics at different altitudes and speeds. Further on, numerical approaches combining finite-difference solutions with a stirred reactor model and finite-rate chemistry were proposed, focusing on the design acpects such as complete engine performance and weight optimizaiton [@harsha1978, @edelman1981]. Later, 1D models with Eulerian-Lagrangian coupling examined stable and unstable combustion modes and their impacts on cycle performance \cite{bhatia1990}, as well as thrust losses due to incomplete combustion and entropy from irreversibility \cite{riggins1995}. O'Brien and colleagues introduced a one-dimensional model to study fuel mixing and ignition timescales in high-speed propulsion \cite{brien2001}. Other models combined low-fidelity propulsion computations with structural integrity for hypersonic engines, estimating performance under aeroelastic conditions \cite{chavez1994, bolender2007}. Birzer and Doolan validated a hydrogen-fueled scramjet combustor model using experimental data from Hyshot-II \cite{birzer2009quasi}. However, these models lacked sufficient combustion modeling. To address this, Torrez et al. developed a reduced-order engine model for mixing and combustion in ramjet and scramjet engines, improving their MASIV tool with the Shapiro method to predict thermal choking position \cite{torrez2011, torrez2013new}. Additionally, Tian et al. introduced a quasi-1D shock approach to estimate pre-combustion conditions and model interactions between isolator flow and combustion modes in dual-mode scramjets and ramjets \cite{tian2014}.

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
