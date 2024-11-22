cmake_minimum_required(VERSION 3.5)

# Название вашего проекта
project(LcardExample)

# Укажите стандарт C++
set(CMAKE_CXX_STANDARD 17)

set(CMAKE_PREFIX_PATH "C:/Qt/5.15.2/msvc2019_64/lib/cmake")
set(HIREDIS_DIR  "C:/Qt/Labs/Lcard/hiredis/hiredis")
set(HIREDIS_BUILD_DIR  "C:/Qt/Labs/Lcard/hiredis/hiredis/build/Debug")
set(LCARD_DIR "C:/Qt/Labs/Lcard/Lcard_packs")

# Создайте исполняемый файл "MyExecutable" и добавьте исходный файл main.cpp
add_executable(MyExecutable main.cpp
    Lcard_wrapper.h
    Lcard_wrapper.cpp
    redis_wrapper.h redis_wrapper.cpp
   )

# Укажите путь к заголовочным файлам
include_directories(${HIREDIS_DIR})
include_directories(${LCARD_DIR}/include)

# Укажите путь к файлам библиотеки
link_directories("${LCARD_DIR}/lib/msvc")

# Укажите библиотеки для линковки с исполняемым файлом
target_link_libraries(MyExecutable "${LCARD_DIR}/lib/msvc/ltrapi.lib" "${LCARD_DIR}/lib/msvc/ltr114api.lib" "${HIREDIS_BUILD_DIR}/hiredisd.lib" ws2_32)
