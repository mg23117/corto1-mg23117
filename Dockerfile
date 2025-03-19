# Para poder compilar el proyecto con Maven en la versión 3.9.9 y OpenJDK 17
FROM openjdk:17-jdk-alpine AS builder

RUN apk add --no-cache maven

# Establecemos el directorio donde vamos a trabajar
WORKDIR /app

COPY . .

# lo usamos para poder ejecuta la compilación y usamos -DskipTests para omitir la ejecución de pruebas al momento de compilar y empaquetar el proyecto.
RUN mvn clean package -DskipTests

# Creamos la imagen final usando OpenJDK 17 alpine
FROM openjdk:17-jdk-alpine

# Establecemos el directorio donde vamos a trabajar
WORKDIR /app

# Con esto logramos nada más copiar el JAR ya compilado
COPY --from=builder /app/target/*.jar app.jar

# Exponer el puerto 8080
EXPOSE 8080

# Ejecuta la aplicación
CMD ["java", "-jar", "app.jar"]