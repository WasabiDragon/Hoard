extends Resource
class_name level_gen_stats

@export var waves: int
@export var wave_variance: int = 1
@export_range(0,10) var minTier: int 
@export_range(0,10) var maxTier: int 
@export_range(0,10) var bossTier: int 