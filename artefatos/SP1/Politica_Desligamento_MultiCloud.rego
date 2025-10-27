package finops.policy.desligamento

# Política de Desligamento Automático Multi-Cloud
# Autor: Marcos Vinicius Leal Garcia
# XP Educação – Outubro/2025

deny[msg] {
    input.tags.dono == ""
    msg := "Recurso sem tag 'dono' será desligado automaticamente."
}

deny[msg] {
    input.utilizacao < 20
    msg := sprintf("Recurso com utilização de %v%% está ocioso e será desligado.", [input.utilizacao])
}

deny[msg] {
    input.tags.ambiente == "desenvolvimento"
    input.horario_atual > "20:00"
    msg := "Ambiente de desenvolvimento fora do horário comercial será desligado para economia de custos."
}
