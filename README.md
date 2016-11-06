# SPMeT
### Single Particle Model with Electrolyte and Temperature: An Electrochemical-Thermal Battery model

Originally published November 5, 2016 by Professor Scott Moura  
Energy, Controls, and Applications Lab (eCAL)  
University of California, Berkeley  
http://ecal.berkeley.edu/  

## Executive Summary
This repository provides Matlab code for the Single Particle Model with Electrolyte (SPMe). The SPMe can be run and edited from filename [spme.m](spme.m). Future versions will include the Single Particle Model with Electrolyte and Temperature (SPMeT) dynamics. The SPMe model code is based upon the equations in the publication below.  

> ["Battery State Estimation for a Single Particle Model with Electrolyte Dynamics"](https://ecal.berkeley.edu/pubs/SPMe-Obs-Journal-Final.pdf)  
> by S. J. Moura, F. Bribiesca Argomedo, R. Klein, A. Mirtabatabaei, M. Krstic  
> IEEE Transactions on Control System Technology, to appear  
> DOI: [10.1109/TCST.2016.2571663](http://dx.doi.org/10.1109/TCST.2016.2571663)  

Specifically, the code models the following dynamics:  
* Solid-phase lithium diffusion
* Electrolyte-phase lithium diffusion
* Assumes isothermal operation (SPMe only)
* Surface and bulk concentrations of lithium in solid-phase single particles
* Voltage  

The model requires the following inputs:  
* __Parameter file:__ A parameter file in directory ``/param`` which provides model parameter values that correspond to a particular chemistry. For example, ``params_LCO.m`` provides model parameter values for a graphite anode/lithium cobalt oxide cathode.
* __Input current trajectory:__ A definition or input file that provides a time series of electric current applied to the battery cell model in terms of A/m^2.
* __Initial conditions:__ Initial conditions values for the state variables. These include:
  - Voltage: Initial voltage ``V0``. Variable ``V0`` and the moles of solid phase lithium ``p.n_Li_s`` in the parameter structure together are used to compute initial conditions for solid phase lithium ``csn0`` and ``csp0``