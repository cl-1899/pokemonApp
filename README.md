<img src="https://img.shields.io/badge/Swift-UIKit-brightgreen">

# PokemonApp

## Описание

PokemonApp - это приложение для просмотра информации о покемонах. Приложение отображает список имен покемонов с поддержкой пагинации и предоставляет подробности о каждом покемоне, включая изображение, имя, тип, вес и высоту. 

## Особенности

- **Список Покемонов**: Отображает имена покемонов из [API](https://pokeapi.co/api/v2/pokemon) с поддержкой пагинации.
- **Подробная Информация**: При нажатии на покемона в списке открывает страницу с подробной информацией, включая:
  - Изображение покемона
  - Имя покемона
  - Тип покемона
  - Вес покемона в килограммах
  - Рост покемона в сантиметрах
  - Кнопка "Назад" для возврата к списку покемонов.
- **Обработка Состояний**: Приложение обрабатывает различные состояния, такие как отсутствие интернет-соединения, ошибки при загрузке данных и другие.
- **Кэширование Данных**: Для поддержки работы в офлайн-режиме данные кэшируются в базе данных.

## Архитектура

- VIPER

## Технологии

- Swift
- Pagination
- URLSession
- DispatchQueue
- Reachability
- CoreData
- UnitTests

## Демонстрация работы приложения

![Pagination](https://github.com/cl-1899/pokemonApp/blob/main/Screenshots/pagination.gif) | ![Pokemon Data](https://github.com/cl-1899/pokemonApp/blob/main/Screenshots/pokemonData.gif)  |  ![Network Error](https://github.com/cl-1899/pokemonApp/blob/main/Screenshots/networkError.gif)
