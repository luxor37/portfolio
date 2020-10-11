FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /portfolio

# Copy csproj and restore as distinct layers
COPY Orchard/*.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY Orchard/. ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /portfolio
COPY --from=build-env /portfolio/out .
ENTRYPOINT ["dotnet", "Portfolio.dll"]
