# 2D pMOSFET (40nm technology)
# ------------------------------

math coord.ucs

# Declare initial grid (half #structure)
# -------------------------------------

line x location= 0.0      spacing= 1.0<nm>  tag= SiTop        
line x location= 50.0<nm> spacing= 10.0<nm>                    
line x location= 0.5<um>  spacing= 50.0<nm>                      
line x location= 2.0<um>  spacing= 0.2<um>                       
line x location= 4.0<um>  spacing= 0.4<um>                       
line x location= 10.0<um> spacing= 2.0<um>  tag= SiBottom   

line y location= 0.0      spacing= 50.0<nm> tag= Mid         
line y location= 0.3<um> spacing=50.0<nm>  tag= Right       

# Silicon substrate definition
# ----------------------------
region Silicon xlo= SiTop xhi= SiBottom ylo= Mid yhi= Right

# Initialize the simulation
# -------------------------
init concentration= 1.0e+16<cm-3> field= Boron
AdvancedCalibration 

# P-well, anti-punchthrough & Vt adjustment implants
# --------------------------------------------------
implant  Phosphorus  dose= 5.0e13<cm-2>  energy= 50<keV> tilt= 0 rotation= 0  
SetPlxList   {PTotal}
WritePlx n@node@_PMOS_substrate.plx  y=0.0 Silicon

#implant  Phosphorus  dose= 1.0e13<cm-2>  energy= 95<keV> tilt= 0 rotation= 0  
#SetPlxList   {PTotal}
#WritePlx n@node@_PMOS_substrate1.plx  y=0.0 Silicon
#implant  Phosphorus  dose= 2.0e12<cm-2>  energy= 50<keV> tilt= 0 rotation= 0  
#SetPlxList   {PTotal}
#WritePlx n@node@_PMOS_substrate2.plx  y=0.0 Silicon

diffuse temperature= 950<C> time= 8.0<s>   
SetPlxList   {PTotal}
WritePlx n@node@_PMOS_substrate3.plx  y=0.0 Silicon

# Global Mesh settings for automatic meshing in newly generated layers
# --------------------------------------------------------------------
grid set.min.normal.size= 1<nm> set.normal.growth.ratio.2d= 1.5
mgoals accuracy= 1e-5
pdbSet Oxide Grid perp.add.dist 1e-7
pdbSet Grid NativeLayerThickness 1e-7

# Gate oxidation
# --------------
diffuse temperature= 850<C> time= 1.0<min> O2

# Poly gate deposition
# --------------------
deposit material= {PolySilicon} type= anisotropic time= 1 rate= {0.06}

# Poly gate pattern/etch
# ----------------------
mask name= gate_mask left=-1 right= 19<nm>
etch material= {PolySilicon} type= anisotropic time= 1 rate= {0.2} \
  mask= gate_mask
struct tdr= n@node@_PMOS1;
etch material= {Oxide}       type= anisotropic time= 1 rate= {0.003}
struct tdr= n@node@_PMOS2; # PolyGate

# Poly reoxidation
# ----------------
diffuse temperature= 850<C> time= 2.0<min>  O2 
struct tdr= n@node@_PMOS3 ; # Poly Reox

# LDD implantation
# ----------------
refinebox Silicon min= {0.0 0.05} max= {0.1 0.12} xrefine= {0.01 0.01 0.01} \
                                                  yrefine= {0.01 0.01 0.01} add
grid remesh
implant Boron dose= 1e12<cm-2> energy= 1<keV> tilt= 0 rotation= 0
struct tdr= n@node@_PMOS4 ; # LDD Implant
diffuse temperature= 1050<C> time= 0.1<s> ; # Quick activation
struct tdr= n@node@_PMOS5 ; # LDD Diffuse

# Halo implantation: Quad HALO implants
# -------------------------------------
implant Arsenic dose= 0.25e10<cm-2> energy= 5<keV> tilt= 30<degree> rotation= 0
struct tdr= n@node@_PMOS6 ; # Halo 1
implant Arsenic dose= 0.25e10<cm-2> energy= 5<keV> tilt= 30<degree> rotation= 90<degree>
struct tdr= n@node@_PMOS7 ; # Halo 1
implant Arsenic dose= 0.25e10<cm-2> energy= 5<keV> tilt= 30<degree> rotation= 180<degree>
struct tdr= n@node@_PMOS8 ; # Halo 1
implant Arsenic dose= 0.25e10<cm-2> energy= 5<keV> tilt= 30<degree> rotation= 270<degree>
struct tdr= n@node@_PMOS9 ; # Halo 1

# RTA of LDD/HALO implants
# ------------------------
diffuse temperature= 1050<C> time= 1<s>
struct tdr= n@node@_PMOS10 ; # Halo RTA

# Nitride spacer
# --------------
deposit material= {Nitride} type= isotropic  time= 1 rate= {0.02}
struct tdr= n@node@_PMOS11 ; # Spacer deposition
etch    material= {Nitride} type= anisotropic time = 1 rate= {0.03} isotropic.overetch= 0.01
struct tdr= n@node@_PMOS12 ; # Spacer etch				
etch    material= {Oxide}   type= anisotropic time= 1 rate= {0.005} 
struct tdr= n@node@_PMOS13 ; # Spacer oxide removal

# P+ implantation
# ---------------
refinebox Silicon min= {0.04 0.12} max= {0.18 0.4} xrefine= {0.01 0.01 0.01} \
                                                   yrefine= {0.05 0.05 0.05} add
grid remesh
implant Boron dose= 1e13<cm-2> energy= 4<keV> tilt= 7<degree> rotation= -90<degree> 
struct tdr= n@node@_PMOS14 ; # P+ implantation

# Final RTA
# ---------------------------
diffuse temperature= 1050<C> time= 1<s> 
struct tdr= n@node@_PMOS15 ; # Final RTA

# RMG
# ---------------------------
mask name= rmg_mask left= 0.01864<um> right= 0.30<um>
etch material= {PolySilicon} type= isotropic time= 1 rate= {0.07} mask= rmg_mask
struct tdr= n@node@_PMOS15_rmg;

#HK material deposizione anisotropic
deposit material= {HfO2} type= anisotropic time= 1 rate= {0.0025} mask= rmg_mask
struct tdr= n@node@_PMOS15_HFO2 ; # Hafnium Dioxide Dep

deposit material= {Tungsten} type= anisotropic time= 1 rate= {0.054} mask= rmg_mask
mask name= gate_mask_2 left= 0.01889<um> right= 0.055<um> negative
etch material= {Tungsten} type= anisotropic time= 1 rate= {0.15} mask= gate_mask_2
struct tdr= n@node@_PMOS15_T_dep ; # Tungsten deposition and etching


# silicidation
# ---------------------------
mask name= silicide_mask left= 0.00<um> right= 0.04081<um>
deposit material= {Titanium} type= anisotropic time= 1 rate= {0.0015} mask= silicide_mask
struct tdr= n@node@_PMOS16_silicide_dep; # SilicideMask
diffuse temperature= 650<C> time= 1.00<s>
struct tdr= n@node@_PMOS16_silicide_diff; 

# Contacts
# --------
deposit material= {Tungsten} type= isotropic time= 1 rate= {0.02} mask= silicide_mask
struct tdr= n@node@_PMOS17 ; # W deposition
mask name= contacts_mask left= 0.0<um> right= 0.25<um>  
etch material= {Tungsten} type= anisotropic time= 1 rate= {0.15} mask= contacts_mask
struct tdr= n@node@_PMOS18 ; # W etching 1
etch material= {Tungsten} type= anisotropic time= 1 rate= {0.15} mask= gate_mask_2
struct tdr= n@node@_PMOS19 ; # W etching 2

# Reflect
# -------
transform reflect left 

# save final structure:
#  - 1D cross sections
struct tdr= n@node@_PMOS20 ; # Final

SetPlxList   {PTotal NetActive}
WritePlx n@node@_PMOS_channel.plx  y=0.0 Silicon

SetPlxList   {BTotal PTotal NetActive}
WritePlx n@node@_PMOS_ldd.plx y=0.028 Silicon

SetPlxList   {BTotal PTotal NetActive}
WritePlx n@node@_PMOS_sd.plx y=0.19 Silicon

# Contacts
# -------
contact bottom name = substrate Silicon
contact name = gate x = -0.04 y = 0.0 Tungsten
contact name = source x = -0.019 y=-0.2 Tungsten
contact name = drain x = -0.019 y = 0.2 Tungsten
struct tdr= n@node@_presimulation


exit
