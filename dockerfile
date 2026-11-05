#sTAGE 1: BUILD STAGE
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR / 

# restore dependencies
COPY ["ContainerizationTest/ContainerizationTest.csproj", "ContainerizationTest/"]
RUN dotnet restore "ContainerizationTest/ContainerizationTest.csproj"

# Build
COPY ["ContainerizationTest/", "ContainerizationTest/"]
WORKDIR /ContainerizationTest
RUN dotnet build "ContainerizationTest.csproj" -c Release -o /app/build

# Stage 2: Publish Stage
FROM build AS publish
RUN dotnet publish "ContainerizationTest.csproj" -c Release -o /app/publish

# Stage 3: Run Stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0
ENV ASPNETCORE_HTTP_PORTS=5001
EXPOSE 5001
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ContainerizationTest.dll"]
