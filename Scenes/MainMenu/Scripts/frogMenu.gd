extends TextureRect

@onready var frog_reflexion: TextureRect = $"../FrogReflexion"

# Configurações de movimento
@export var amplitude_posicao: Vector2 = Vector2(5.0, 3.0)  # Quanto o barco se move (x, y)
@export var amplitude_rotacao: float = 0.1                   # Quanto o barco rotaciona (em radianos)
@export var velocidade: float = 2.0                          # Velocidade da animação
@export var offset_tempo: float = 0.0                        # Para sincronizar múltiplos barcos

var tempo: float = 0.0
var posicao_inicial: Vector2
var frog_reflexion_posicao_inicial: Vector2

func _ready():
	# Guarda a posição inicial como referência
	posicao_inicial = position
	frog_reflexion_posicao_inicial = frog_reflexion.position

func _process(delta):
	tempo += delta * velocidade
	
	# Calcula movimentos com funções de onda
	var onda_x = sin(tempo + offset_tempo)
	var onda_y = cos(tempo * 1.3 + offset_tempo)  # Multiplicador 1.3 para tornar o movimento assimétrico
	
	# Aplica movimento de posição
	position = posicao_inicial + Vector2(
		onda_x * amplitude_posicao.x,
		onda_y * amplitude_posicao.y
	)
	frog_reflexion.position = frog_reflexion_posicao_inicial + Vector2(
		onda_x * amplitude_posicao.x,
		onda_y * amplitude_posicao.y
	)
	
	var rotacao_extra = sin(tempo * 1.5) * 0.05  # Movimento adicional irregular
	rotation = (onda_x * amplitude_rotacao) + rotacao_extra
	frog_reflexion.rotation = (onda_x * amplitude_rotacao) + rotacao_extra
