cmake_minimum_required(VERSION 3.5)

project(tickets LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Quick QuickControls2 LinguistTools REQUIRED)

set(TS_FILES tickets_ru_RU.ts)
set(PROJECT_NAME "tickets")
set(FULL_PROJECT_NAME "tickets.mikhael")

# This command figures out the target architecture for use in the manifest file
execute_process(
    COMMAND dpkg-architecture -qDEB_HOST_ARCH
    OUTPUT_VARIABLE CLICK_ARCH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

configure_file(manifest.json.in ${CMAKE_CURRENT_BINARY_DIR}/manifest.json)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json DESTINATION /)
install(FILES tickets.apparmor DESTINATION /)
install(FILES tickets.desktop DESTINATION /)
install(DIRECTORY assets DESTINATION /)

add_executable(tickets
  main.cpp
  qml/qml.qrc
  ${TS_FILES}
)
install(TARGETS tickets RUNTIME DESTINATION /)

target_compile_definitions(tickets
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(tickets
  PRIVATE Qt5::Core Qt5::Quick Qt5::QuickControls2)

qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
