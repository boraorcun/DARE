---
title: 'Gala: A Python package for galactic dynamics'
tags:
  - Python
  - astronomy
  - dynamics
  - galactic dynamics
  - milky way
authors:
  - name: Adrian M. Price-Whelan
    orcid: 0000-0000-0000-0000
    equal-contrib: true
    affiliation: "1, 2" # (Multiple affiliations must be quoted)
  - name: Author Without ORCID
    equal-contrib: true # (This is how you can denote equal contributions between multiple authors)
    affiliation: 2
affiliations:
 - name: Lyman Spitzer, Jr. Fellow, Princeton University, United States
   index: 1
   ror: 00hx57361
 - name: Institution Name, Country
   index: 2
 - name: Independent Researcher, Country
   index: 3
date: 13 August 2017
bibliography: paper.bib

---

# Summary

The forces on stars, galaxies, and dark matter under external gravitational
fields lead to the dynamical evolution of structures in the universe. The orbits
of these bodies are therefore key to understanding the formation, history, and
future state of galaxies. The field of "galactic dynamics," which aims to model
the gravitating components of galaxies to study their structure and evolution,
is now well-established, commonly taught, and frequently used in astronomy.
Aside from toy problems and demonstrations, the majority of problems require
efficient numerical tools, many of which require the same base code (e.g., for
performing numerical orbit integration).

The development of supersonic civil aviation with an emphasis on enhanced technical and environmental sustainability calls for a comprehensive approach to supersonic aircraft design and performance characterization. These designs must not only meet high-speed flight demands but also accommodate diverse external conditions throughout their missions, requiring optimization across multiple operating points for aerodynamic and propulsive systems \cite{kuchemann2012}. Thus, configuring, optimizing, and investigating a high-speed propulsion system is a pivotal step in realizing supersonic and hypersonic aircraft. In terms of a propulsion system architecture that can comply with the mission definitions of high-speed aircraft, ramjet engines offer significant advantages over rocket engines, as they do not require onboard oxidizer storage or rotating parts. Despite their simpler structure compared to turbo-based aero-engines, the internal flow dynamics of ramjets are complex and must be meticulously studied to ensure system stability and high performance \cite{murthy2001scramjet}. 

# Statement of need

Conceptual design methods using zero- and one-dimensional approaches are therefore cost-effective alternatives to high-fidelity numerical simulations. They allow analysis of the design parameters and operational variables of each major component, as well as assessing propulsive performance metrics such as thrust, specific impulse, and fuel consumption \cite{ma2019control, tian2014quasi}. In this regard, reduced order models for high-speed propulsion systems, including ramjet and scramjet engine configurations, have been developed and tested since the mid-1960s. Early low-fidelity models analyzed how fuel injection and mixing affect the ramjet/scramjet cycle by simulating flow through intake contours using a two-shock approach \cite{bauer1966}. These models examined critical conditions in the combustion chamber, such as pre-ignition states, fuel mixing, ignition methods, and combustor length reduction, while exploring propulsion system characteristics at various altitudes and speeds. To enhance performance and reduce weight of ramjet engines, a numerical approach combining finite-difference solutions with a well-stirred reactor model and finite-rate chemistry was proposed, incorporating a shear layer model to account for viscous effects \cite{harsha1978, edelman1981}. Schindel developed a performance estimation framework for ramjet/scramjet engines, using a mix of non-isentropic and isentropic compression properties, variable cross-sectional area combustor chambers with continuous fuel burn, and isentropic expansion through the nozzle for integrated airframe performance characterization \cite{schindel1990}. Later studies introduced 1D models with Eulerian-Lagrangian coupling to examine both stable and unstable combustion modes and their impacts on cycle performance \cite{bhatia1990}. Riggins and Clinton also modeled thrust losses due to incomplete fuel burning and entropy losses from irreversibility using aerothermodynamics principles \cite{riggins1995}.

In subsequent research, O'Brien and colleagues proposed a one-dimensional model for high-speed propulsion flow paths, incorporating finite-rate chemistry to examine how fuel mixing and ignition timescales affect various engine operating conditions \cite{brien2001}. They studied the impact of area changes, friction, mass injection, fuel mixing, and heat transfer to the combustor walls on performance of rocket-based combined-cycle (RBCC) and scramjet engines. Other studies developed physics-based models to combine low-fidelity propulsion computations with structural integrity considerations for air-breathing hypersonic engines, estimating propulsive performance under different aeroelastic modes \cite{chavez1994, bolender2007}. Similarly, Birzer and Doolan developed a model for a hydrogen-fueled scramjet combustor using a set of one-dimensional ordinary differential equations, validating their approach with experimental data from the Hyshot-II cases \cite{birzer2009quasi}. They highlighted the model's ability to estimate thrust but acknowledged that it could not predict the two-dimensional pressure peaks arising from supersonic combustion. However, these models lacked adequate combustion modeling, failing to consider the aerothermochemical effects of gas mixing and burning in the combustion chamber. 

In order to resolve these issues, Torrez et al. created a reduced-order engine model for high-speed propulsion systems, simulating mixing and combustion in ramjet and scramjet engines \cite{torrez2011}. This model, called MASIV, used tabulated presumed probability distribution function flamelet chemistry to generate low-fidelity combustion data, making it suitable for design and optimization due to significantly shorter computation times compared to numerical and experimental methods. The authors improved their MASIV numerical tool by coupling it with the Shapiro method to predict the thermal choking position, which is a mathematical singularity in the ramjet engine duct \cite{torrez2013new}. Additionally, Tian et al. introduced a quasi-1D strength-adaptable shock approach to estimate pre-combustion conditions, modeling the interactions between flow development in the isolator and the combustion modes of dual-mode scramjets or ramjets \cite{tian2014}. This approach was used to estimate heat release distributions accounting for area changes, friction, and mass injection within the combustion chamber. 

Although there are numerous low-fidelity design and analysis studies aimed at accurately characterizing the performance specifications of ramjet engines, most focus on individual components of the propulsion system rather than a comprehensive methodology. Few studies consider the combined influence of flight conditions and design parameters throughout the entire propulsive flow path. Therefore, this study integrates individual design and analysis approaches for high-speed propulsion components to develop a holistic, low-fidelity design method for cost-efficient characterization of the ramjet engine design space. Accordingly, `RASDAS` is developed.

# Research applications

Ramjet propulsion is often favored for powering supersonic vehicles cruising at speeds exceeding Mach 3. Despite the relatively simple geometric design of these engines compared to turbo-based alternatives, the complex flow physics involved makes their design and optimization challenging. Hence, the design and performance analysis of ramjet engines are crucial to ensure that the propulsion system meets the demands of the flight trajectory. To address this, a design and analysis methodology using zero-and-one dimensional models, Busemann intakes, and detailed chemistry approach is applied to explore the design space of ramjet engines. By investigating design parameters across a wide range of operational conditions, a multi-dimensional data matrix is generated. Employing a sensitivity analysis technique referred to as Shapley Additive Explanations (SHAP) framework, the propulsive performance characteristics under various operational and design conditions are discussed.

The scramjet design space is generated by varying parameters which are flight Mach number and altitude, intake truncation angle, intake exit Mach number and equivalence ratio. Performance outputs of total pressure recovery factor, compression ratio, captured air mass flow rate, intake startability index, thrust, specific impulse, fuel consumption and overall efficiency are computed for each design scenario. The generated database is visualized via performance maps and analyzed in terms of propulsive characteristics. A feature importance study is also conducted to quantify the effects of design parameters on the propulsive performance.

Therefore, this study introduces a reduced order holistic approach for design and assessment of the flow development in high-speed propulsion systems composed of generic elements of ramjet/scramjet engine configurations. Accordingly, the intakes designed based on axisymmetric flow templates are used to provide the necessary freestream flow modulation prior to the isolator through which a normal shock assumption is applied. The resultant flow properties are utilized for the combustion module where the flow expansion within the combustor and nozzle components are computed based on 1D steady inviscid flow equations coupled with detailed chemistry approach and JANAF tables. The module was validated and verified with the experimental and numerical data obtained for a dual-mode ramjet/scramjet combustor. Consequently, the parameters such as thrust, fuel consumption and specific impulse are calculated to quantify the engine performance for each design. Finally, the employment of the low fidelity model is demonstrated over a family of ramjet flow paths where the design space is confined based on the requirements of a high-supersonic cruise vehicle.

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
