# gMLC
# Guy Y. Cornejo Maceda, 01/07/2021
# Copyright: 2021 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
# CC-BY-SA

Gradient-enriched machine learning control for fast feedback control law optimization.
This software is based on a Genetic Programming framework to build control laws for dynamical systems.
The genetic operators are remplaced by two phases:
- exploitation (downhill simplex)
- exploration (evolution with mutation and crossover)

## Publication
Cornejo Maceda, G., Li, Y., Lusseyran, F., Morzyński, M., & Noack, B. (2021). Stabilization of the fluidic pinball with gradient-enriched machine learning control. <i>Journal of Fluid Mechanics,</i> <i>917</i>, A42. doi:10.1017/jfm.2021.301

## Getting Started

Unzip the tar.gz file.

### Prerequisites

The software needs MATLAB.
This version has been developped on MATLAB version 9.5.0.944444 (R2018b)
Please contact gy.cornejo.maceda@gmail.com in case of error.

### Content
The main folder should contain the following folders and files:
- *README.md*
- *Initialization.m*, *Restart.m*, to initialize and restart the toy problem.
- *@LGPC/*, *@LGPCind/*, *@LGPCpop/*, *@LGPCtable/* contains the object definition files for "classic" LGPC algorithm.
- *@gMLC/*, *@gMLCsimplex/*, *@gMLChistory/*, *@gMLCind/*, *@gMLCtable/* contains the object definition files for gMLC.
- *Analysis/* folder for analysis.
- *gMLC_tools/* contains functions used in gMLC
- *Other_tools/* contains other functions such ODE solvers.
- *Plant/* contains all the problems and associated parameters. One folder for each problem. Default parameters are in *gMLC_tools/*.
- *save_runs/* contains the savings.

### Initialization and run

To start, run matlab in the main folder, then run Initialization.m to load the folders and class object.

```
Initialization;
```

A *gmlc* object is created containing the toy problem.
The toy problem is the interpolation of a tanh function.
For more interesting behavior, work on the Generalized Mean-Field Model (GMFM).
To load a different problem, just specify it when the gMLC object is created.

```
gmlc=gMLC('oscillator');
gmlc.show_problem;
```

To start the optimization process of the toy problem, run the *go.m* method.
Run alone it process one cycle of optimization.
For the first iteration, it will initialize the data base with new individiduals following a giving method (Monte Carlo by defaul).

```
gmlc.go;
```


## Post processing and analysis.

To visualize the best individual, use :

```
gmlc.show;
```

To visualize the learning process, use : 

```
gmlc.plot_progress;
```

### Useful parameters

```
gmlc.parameters.name = 'NameOfMyRun'; % This is the used to save;
gmlc.parameters.save_data=1; % Save actuation and sensor data.
gmlc.parameters.Number_MonteCarlo_Init = 100; % Number of individuals generated in the initialization step;
	% For Monte-Carlo, it gives 100 random individuals.
gmlc.parameters.SimplexSize = 10; % Size of the downhill simplex subpsace.
gmlc.parameters.actuation_limit=[-1,1]; % The actuation is bounded between -1 and 1.
```

### Save/Load

One can save and load one run.
/!\ When loading, the gmlc object will be overwritten, be careful!

```
gmlc.save;
gmlc.load('NameOfMyRun');
```

## Versioning

Version 0.1 - First GitHub release.

## Author

* **Guy Y. Cornejo Maceda** 

## License

gMLC (Gradient-enriched Machine Learning Control) for taming nonlinear dynamics.
    Copyright (c) 2019, Guy Y. Cornejo Maceda (gy.cornejo.maceda@gmail.com)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Acknowledgments

* The author thanks Thomas Duriez and Ruying Li for the great help they provided by sharing their own code.
* The author also thanks Bernd R. Noack (http://berndnoack.com/) and Francois Lusseyran (https://perso.limsi.fr/lussey/) for their precious advice and guidance.
