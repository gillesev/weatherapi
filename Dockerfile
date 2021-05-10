FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build website
COPY . .
WORKDIR /app/.
RUN dotnet build "weatherapi.csproj" -c release -o /app/build --no-restore

FROM build AS publish
RUN dotnet publish "weatherapi.csproj" -c release -o /app/publish

# Final stage / image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "weatherapi.dll"]