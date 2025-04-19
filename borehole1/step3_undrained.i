[Mesh]
  file = 'step3.msh'
  construct_side_list_from_node_list = true
[]


[GlobalParams]
  displacements = 'disp_x disp_y'
  gravity = '0 0 0'
  biot_coefficient = 1.0
  PorousFlowDictator = dictator
[]

[Variables]
  [porepressure]
    initial_condition = 1e6
  []
  [disp_x]
    initial_condition = 0
    scaling = 1e-5
    order = FIRST
    family = LAGRANGE
  []
  [disp_y]
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
  displacements = 'disp_x disp_y'
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
    type = ComputeSmallStrain
  []
  [stress]
    type = ComputeLinearElasticStress
  []
[]

[Kernels]
  [stress_x]
    type = StressDivergenceTensors
    variable = disp_x
    component = 0
    use_displaced_mesh = false
  []
  [stress_y]
    type = StressDivergenceTensors
    variable = disp_y
    component = 1
    use_displaced_mesh = false
  []
  [poro_x]
    type = PorousFlowEffectiveStressCoupling
    variable = disp_x
    component = 0
    use_displaced_mesh = false
  []
  [poro_y]
    type = PorousFlowEffectiveStressCoupling
    variable = disp_y
    component = 1
    use_displaced_mesh = false
  []
[]

[BCs]
  [constant_withdrawal]
    type = PorousFlowSink
    variable = porepressure
    boundary = abs_well
    flux_function = '-1000 * 315e-6 / (2 * pi * 1 * 20)'
  []

  [constant_injection]
    type = PorousFlowSink
    variable = porepressure
    boundary = inj_well
    flux_function = '1000 * 315e-6 / (2 * pi * 1 * 20)'
  []


  [fixed_x_displacement]
    type = DirichletBC
    variable = disp_x
    value = 0
    boundary = 'left right'
  []

  [fixed_y_displacement]
    type = DirichletBC
    variable = disp_y
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
  [pressure_left]
    type = LineValueSampler
    start_point = '0 12.5 0'
    end_point   = '14 12.5 0'
    num_points = 30
    variable = porepressure
    warn_discontinuous_face_values = false
    sort_by = x
    execute_on = timestep_end
  []

  [pressure_middle]
    type = LineValueSampler
    start_point = '16 12.5 0'
    end_point   = '34 12.5 0'
    num_points = 40
    variable = porepressure
    warn_discontinuous_face_values = false
    sort_by = x
    execute_on = timestep_end
  []

  [pressure_right]
    type = LineValueSampler
    start_point = '36 12.5 0'
    end_point   = '50 12.5 0'
    num_points = 30
    variable = porepressure
    warn_discontinuous_face_values = false
    sort_by = x
    execute_on = timestep_end
  []

  [disp_left]
    type = LineValueSampler
    start_point = '0 12.5 0'
    end_point   = '14 12.5 0'
    num_points = 30
    variable = disp_y
    warn_discontinuous_face_values = false
    sort_by = x
    execute_on = timestep_end
  []

  [disp_middle]
    type = LineValueSampler
    start_point = '16 12.5 0'
    end_point   = '34 12.5 0'
    num_points = 40
    variable = disp_y
    warn_discontinuous_face_values = false
    sort_by = x
    execute_on = timestep_end
  []

  [disp_right]
    type = LineValueSampler
    start_point = '36 12.5 0'
    end_point   = '50 12.5 0'
    num_points = 30
    variable = disp_y
    warn_discontinuous_face_values = false
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