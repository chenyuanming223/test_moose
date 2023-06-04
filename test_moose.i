[Mesh]
  # file = cubic_hex.msh
  # [cubic]
  # type = GeneratedMeshGenerator
  # nx=10
  # ny=10
  # nz=10
  # dim=3
  # xmax=5
  # ymax=5
  # zmax=5
  # []
  type = FileMesh
  file = BCC10_441_tetra.msh
[]
# [Contact]
#   [self_contact]
#     primary = 'allself'
#     secondary = 'allself'
#     model = frictionless
#     formulation = penalty
#     penalty = 1.93e5
#     normalize_penalty = true
#     capture_tolerance = 0.0001
#   []
# []

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  large_kinematics = 'true'
  use_displaced_mesh = 'true'
[]

[BCs]
  [bottom_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'bot'
    value = 0
    preset = true
  []
  # [bottom_z]
  #   type = DirichletBC
  #   variable = disp_z
  #   boundary = 'bot'
  #   value = 0
  #   preset = true
  # []
  # [bottom_x]
  #   type = DirichletBC
  #   variable = disp_x
  #   boundary = 'bot'
  #   value = 0
  #   preset = true
  # []
  [top_y]
    type = FunctionDirichletBC
    boundary = 'top'
    function =  -.02*t
    variable = disp_y
    preset = true
  []
  [left_x]
    type = DirichletBC
    value = 0
    variable = disp_x
    boundary = 'left'
  []
  [back_z]
    type = DirichletBC
    value = 0
    variable = disp_z
    boundary = 'back'
  []
[]



[Materials]
  [stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'isoplas'
    max_iterations=100
    absolute_tolerance=1e-4
  []
  # [stress]
  #   type = ComputeLinearElasticStress
  # []
  [isoplas]
    # max_inelastic_increment=0.1
    type = IsotropicPlasticityStressUpdate
    yield_stress = 880
    hardening_constant = 1000
    max_inelastic_increment = 0.1
    # use_substepping = ERROR_BASED
  []
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.93e5
    poissons_ratio = 0.3
  []
  [compute_stress]
    type = ComputeLagrangianWrappedStress
  []
[]



[Outputs]
  exodus = true
  csv = true
[]

[Executioner]
  # dt = 0.005
  type = Transient
  solve_type = PJFNK
  end_time = 100
  dtmin = 1e-10
  dtmax = 2
  automatic_scaling = true
  compute_scaling_once=false
  nl_max_its = 100
  off_diagonals_in_auto_scaling = true
  nl_abs_tol = 1e-12
  nl_rel_tol = 1e-8
  l_tol = 1e-8
  [TimeStepper]
    # Iteration adaptive
    type = IterationAdaptiveDT
    optimal_iterations = 15
    dt = 1e-2
    cutback_factor = .75
    growth_factor = 1.5
  []
[]

[Modules]
  [TensorMechanics]
    [Master]
      [all]
        # additional_generate_output = 'cauchy_stress_xx'
        # additional_material_output_family = 'MONOMIAL'
        # volumetric_locking_correction = true
        formulation = UPDATED
        new_system = true
        add_variables = true
        generate_output = 'vonmises_stress strain_xx strain_yy strain_zz strain_xy strain_xz strain_yz'
        material_output_order = 'SECOND'
        strain = FINITE
        incremental = true
      []
    []
  []
[]

[Problem]
[]

[Preconditioning]
  [smp]
    # petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    # petsc_options_value = ' asm lu NONZERO 2'
    # petsc_options_iname = '-pc_type -snes_type -pc_factor_shift_type -pc_factor_shift_amount'
    # petsc_options_value = 'lu vinewtonrsls NONZERO 1e-10'
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu mumps'
  []
[]
