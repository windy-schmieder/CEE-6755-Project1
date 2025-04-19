[Mesh]
  file = 'step2.msh'
  coord_type = RZ
[]

[GlobalParams]
  displacements = 'disp_r disp_z'
  gravity = '0 0 0'
  biot_coefficient = 1.0
  PorousFlowDictator = dictator
[]

[Variables]
  [porepressure]
    initial_condition = 1e6
  []
  [disp_r]
    initial_condition = 0
    scaling = 1e-5
    order = FIRST
    family = LAGRANGE
  []
  [disp_z]
    initial_condition = 0
    scaling = 1e-5
    order = FIRST
    family = LAGRANGE
  []
[]

[FluidProperties]
  [water]
    type = SimpleFluidProperties
    viscosity = 1e-3
    bulk_modulus = 2.1e9
    density0 = 1000
  []
[]

[PorousFlowFullySaturated]
  coupling_type = HydroMechanical
  porepressure = porepressure
  displacements = 'disp_r disp_z'
  fp = water
[]

[Materials]
  [perm]
    type = PorousFlowPermeabilityConst
    permeability = '1E-12 0 0   0 1E-12 0   0 0 1E-12'
  []
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 5E9
    poissons_ratio = 0.3
  []
  [strain]
    type = ComputeAxisymmetricRZSmallStrain
  []
  [stress]
    type = ComputeLinearElasticStress
  []
[]

[Kernels]
  [stress_r]
    type = StressDivergenceRZTensors
    variable = disp_r
    component = 0
    use_displaced_mesh = false
  []
  [stress_z]
    type = StressDivergenceRZTensors
    variable = disp_z
    component = 1
    use_displaced_mesh = false
  []
  [poro_r]
    type = PorousFlowEffectiveStressCoupling
    variable = disp_r
    component = 0
    use_displaced_mesh = false
  []
  [poro_z]
    type = PorousFlowEffectiveStressCoupling
    variable = disp_z
    component = 1
    use_displaced_mesh = false
  []
[]

[BCs]
  [constant_withdrawal]
    type = PorousFlowSink
    variable = porepressure
    boundary = inner
    flux_function = '-0.0010041085'
  []
  [constant_output_porepressure]
    type = DirichletBC
    variable = porepressure
    value = 1e6
    boundary = outer
  []
  [fixed_radial_displacement]
    type = DirichletBC
    variable = disp_r
    value = 0
    boundary = outer
  []
  [fixed_vertical_displacement]
    type = DirichletBC
    variable = disp_z
    value = 0
    boundary = bottom
  []
[]

[Preconditioning]
  active = basic
  [basic]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Steady
  nl_abs_tol = 1e-8
  solve_type = newton
[]

[VectorPostprocessors]
  [pressure_profile]
    type = LineValueSampler
    warn_discontinuous_face_values = false
    start_point = '1 10 0'
    end_point = '20 10 0'
    num_points = 100
    sort_by = x
    variable = 'porepressure'
    execute_on = TIMESTEP_END
  []
  [surface_disp]
    type = NodalValueSampler
    variable = disp_z
    boundary = top
    sort_by = x
    execute_on = timestep_end
  []
[]

[Outputs]
  exodus = true
  [csv]
    type = CSV
  []
[]
