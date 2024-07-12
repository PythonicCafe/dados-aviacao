# Dados sobre a aviação brasileira

## Dados disponíveis

- `anac_aerodromo.sh`: Cadastro de aeródromos públicos, fonte: ANAC
- `anac_aeronave.sh`: Registro Brasileiro de Aeronaves (RAB), fonte: ANAC
- `cenipa_ocorrencia.sh`: Cadastro de ocorrências (com os tipos e dados das aeronaves), fonte: CENIPA

## Rodando

```shell
make build start bash
```

Dentro do container, execute o script que deseja. Os dados estarão:
- Dados originais (baixados): `docker/data/main/download` (equivalente a `/data/download` no container `main`)
- Dados finais (tratados): `docker/data/main/output` (equivalente a `/data/output` no container `main`)

## Contribuindo

Caso queira contribuir, as próximas tarefas a serem desenvolvidas são:

- Descrever os campos do RAB em `schema/anac_aeronave.csv` (criar coluna `description`), de acordo com o dicionário de
  dados da ANAC
- Criar arquivo `sql/anac_aerodromo.sql` para tratar os dados dos aeródromos (baseie-se em `sql/anac_aeronave.sql`)
- Criar arquivo `sql/cenipa_ocorrencia.sql` para tratar os dados dos aeródromos (baseie-se em `sql/anac_aeronave.sql`)
- Adicionar tabelas:
  - [Voos e operações aéreas (ANAC)](https://sistemas.anac.gov.br/dadosabertos/Voos%20e%20opera%C3%A7%C3%B5es%20a%C3%A9reas/Percentuais%20de%20atrasos%20e%20cancelamentos/2023/04%20-%20abril/)
  - [Voo regular ativo](https://www.anac.gov.br/acesso-a-informacao/dados-abertos/areas-de-atuacao/voos-e-operacoes-aereas/voo-regular-ativo-vra)
  - [Histórico de voos](https://www.gov.br/anac/pt-br/assuntos/dados-e-estatisticas/historico-de-voos)
  - <https://sistemas.anac.gov.br/dadosabertos/Aerodromos/Aer%C3%B3dromos%20P%C3%BAblicos/>
  - <https://sistemas.anac.gov.br/dadosabertos/Aerodromos/Aer%C3%B3dromos%20P%C3%BAblicos/Lista%20de%20aer%C3%B3dromos%20p%C3%BAblicos/>

## Licença

LGPL v3
