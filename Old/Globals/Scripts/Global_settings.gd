extends Node

#controls
var Sensitivity = 1
var Reverse_Mouse = false

#audio
var Audio = true
var Audio_Strenth = 75

var Music = true
var Music_Strenth = 75

var Soundeffect = true
var Soundeffect_Strength = 75

#screen
var godray = 'low'
var godrays = ['disabled', 'low', 'medium', 'high', 'max']

var shadow = 'medium'
var shadows = ['disabled', 'low', 'medium', 'high', 'max']
var shadowfilter = 'PFC5'
var shadowfilters = ['disabled', 'PCF5', 'PCF13']

var reflection = 'low'
var reflections = ['disabled', 'low', 'medium', 'high', 'max']

var msaa = 4
var msaas = [0, 2, 4, 8, 16]

var fxaa = true
var fxaas = [false, true]

var debanding = true
var debandings = [false, true]

var anisotropic_filter = 4
var anisotropic_filters = [2, 4, 8, 16]

var nearest_mipmap = true
var nearest_mipmaps = [false, true]
#subsurface scattering
var quality = 'low'
var qualitys = ['low', 'medium', 'high']

var scale = 1
var scaled = [0, 8]

var follow_surface = true
var follow_surfaces = [false, true]

var weight_samples = true
var weight_sampless = [false, true]

var HDR = true
var HDRs = [false, true]

var high_quality_voxel_cone_tracking = true
var high_quality_voxel_cone_trackings = [false, true]

var Vsync = true
var Vsyncs = [false, true]

var Brigthness = 75

var Resolution = OS.get_screen_size()
var Resolutions = [Vector2(3440, 1440),Vector2(2560, 1440),Vector2(1280, 1024),Vector2(1920, 1200),Vector2(1366, 768),Vector2(1920, 1200 ),Vector2(1280, 720),Vector2(1920, 1080),Vector2(3840, 2160)]
var Standart_Res = Vector2(1920, 1080)

var fullscreen = true
var fullscreens = [false, true]

var FOV = 70
var FOVs = [50, 100]
#physics
var physics_frame = 60
var physics_frames = [15, 600]
