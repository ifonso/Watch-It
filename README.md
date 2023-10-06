# WatchIt

- Minha tentativa de implementar o [desafio BTG](https://github.com/btgpactualdigitaldev/iOS-challenge-BTG#desafio-btg-ios) para dev iOS.

Um aplicativo simples, com persistência local utilizando Core Data, que consome a API do The Movie Database.

## Features

- [x] Tab bar com dois ítens: Filmes e Favoritos, sendo a principal a tab de Filmes;

- A tela de Filmes deverá conter:
    - [x] Uma lista dos filmes populares da API;
    - [x] Cada elemento da lista deve conter o poster, o nome e o ano que o filme foi produzido;
    - [x] Ao clicar em um ítem, deve ser apresentada a tela de detalhes (tela descrita abaixo);
    - [ ] Search bar para pesquisar filmes por nome;

- A tela de favoritos deverá conter:
    - [ ] A lista de favoritos persistidos no app entre sessões;
    - [ ] Search bar para pesquisar favoritos por nome e ano;
    - [ ] Ao clicar em um ítem, deve ser apresentada a tela de detalhes (tela descrita abaixo);

- A tela de detalhes deve apresentar os seguintes dados do filme:
    - [ ] Poster;
    - [ ] Botão para favoritar/desfavoritar;
    - [ ] Título;
    - [ ] Sinopse;
    - [ ] Nota do filme;
    - [ ] E os gêneros por extenso.

> É necessário fazer tratamento de erros e dos fluxos de exceção, como busca vazia, carregando e outros erros que possam ocorrer.