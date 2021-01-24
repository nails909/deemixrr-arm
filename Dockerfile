FROM lsiobase/ubuntu:bionic AS base

WORKDIR /app

EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:3.1-bionic-arm32v7 AS build
WORKDIR /src
COPY ["Deemixrr/Deemixrr.csproj", "Deemixrr/"]
RUN dotnet restore "Deemixrr/Deemixrr.csproj"
COPY . .
WORKDIR "/src/Deemixrr"
RUN dotnet build "Deemixrr.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Deemixrr.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:3.1-bionic-arm32v7

FROM base AS final

WORKDIR /app
COPY --from=publish /app/publish .

RUN apt-get update && \
    apt-get install -y python3 python3-pip apt-transport-https

COPY /etc /etc

ENTRYPOINT ["/init"]
