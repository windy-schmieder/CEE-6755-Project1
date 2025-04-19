[Mesh]
  file = 'step1.msh'
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]

[Variables]
  [porepressure]
    initial_condition = 1e6 
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
  coupling_type = Hydro
  porepressure = porepressure
  gravity = '0 0 0'
  fp = water
[]

[Materials]
  [perm]
    type = PorousFlowPermeabilityConst
    permeability = '1e-08 0 0   0 1e-08 0   0 0 1e-08'
  []
[]


[BCs]
  [constant_withdrawal]
    type = PorousFlowSink
    variable = porepressure
    boundary = inner
    flux_function = '-1000 * 315e-6 / (2 * pi * 1 * 20)' # kg/m2/s
  []

  [constant_output_porepressure]
    type = DirichletBC
    variable = porepressure
    value = 1e6
    boundary = outer
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
  [data]
    type = LineValueSampler
    warn_discontinuous_face_values = false
    start_point = '1 0 0'
    end_point = '20 0 0'
    num_points = 100
    sort_by = x
    variable = 'porepressure'
    execute_on = TIMESTEP_END
  []
[]

[Outputs]
  execute_on = 'initial timestep_end'
  exodus = true
  [csv]
    type = CSV
  []
[]
