File
{
*INPUT FILES
Grid ="n1_presimulation_fps.tdr"
* physical parameters
Parameter = "sdevice.par"

*OUTPUT FILES
Plot = "n@node@_des.tdr"
* electrical characteristics at the electrodes
Current= "n@node@_des.plt"
}

Electrode
{
{ name="source" Voltage=0.0 }
{ name="drain" Voltage=0.0 }
{ name="gate" Voltage=0.0 }
{ name="substrate" Voltage=0.0}
}

Thermode
{
{ Name = "source" Temperature = 300 }
{ Name = "drain" Temperature = 300 }
{ Name = "gate" Temperature = 300 }
{ Name = "substrate" Temperature = 300 }
}

Physics
{
eQuantumPotential
EffectiveIntrinsicDensity( BandGapNarrowing(oldSlotboom) )
Mobility( DopingDep 
	eHighFieldSaturation ( GradQuasiFermi)
	hHighFieldSaturation ( GradQuasiFermi)
	Enormal )
Recombination (
	SRH (DopingDep TempDependence)
	Band2Band(Model = NonLocalPath)
	)
}

Plot
{
eDensity hDensity eCurrent hCurrent
ElectricField eEnormal hEnormal
eQuasiFermi hQuasiFermi
Potential Doping SpaceCharge
eMobility hMobility eVelocity hVelocity
DonorConcentration AcceptorConcentration
Doping
BandGap BandGapNarrowing ElectronAffinity
ConductionBandEnergy ValenceBandEnergy
eQuantumPotential
Band2BandGeneration
}


Math
{
Extrapolate
* use full derivatives in Newton method
Derivatives
* control on relative and absolute errors
RelErrControl
* relative error= 10^(-Digits)
Digits=5
* absolute error
Error(electron)=1e8
Error(hole)=1e8
* numerical parameter for space-charge regions
eDrForceRefDens=1e10
hDrForceRefDens=1e10
Notdamped=50
* maximum number of iteration at each step
Iterations=100
ExitOnFailure
* solver of the linear system
Method=ParDiSo
Wallclock
NoSRHperPotential
}

Solve
{
coupled {Poisson}
coupled{ Poisson Electron Hole }

quasistationary (InitialStep = 0.01 MaxStep = 0.01 MinStep=1e-2
Goal {name= "drain" voltage = -1}
plot { range=(-1, 1) intervals=1 }
){coupled { Poisson  Electron Hole }}

quasistationary (InitialStep = 1e-2 MaxStep = 0.001 MinStep=1e-3
Goal {name= "gate" voltage = -2}
plot { range=(-1, 1) intervals=3 }
){coupled { Poisson Electron Hole } }
}
