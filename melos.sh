#https://pub.dev/packages/melos
#https://melos.invertase.dev/~melos-latest/
#https://docs.web3js.org/api

# comandos para administrar proyectos con melos


# instalar melos
dart pub global activate melos

# instalar dependencias en todos los proyectos
melos run get --no-select

# supervisar dependencias en todos los proyectos
melos run outdated --no-select;

# formatear todos los proyectos
melos run format --no-select

# analizar todos los proyectos
melos run analyze --no-select

# testear todos los proyectos
melos run test --no-select

# testear proyecto individualmente
melos run test
