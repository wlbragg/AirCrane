# =====
# Doors
# =====
crew       = aircraft.door.new("/sim/model/door-positions/crew", 2, 0 );
passenger  = aircraft.door.new("/sim/model/door-positions/passenger", 2, 0 );
engineer   = aircraft.door.new("/sim/model/door-positions/engineer", 2, 0 );
starboard   = aircraft.door.new("/sim/model/door-positions/starboard", 2, 0 );

# ================================
# external fire suppression system
# ================================
ramscoop = aircraft.door.new("/sim/model/firetank/deployramscoop", 2, 0 );
flexhose = aircraft.door.new("/sim/model/firetank/deployflexhose", .79, 1 );
