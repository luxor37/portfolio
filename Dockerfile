FROM microsoft/dotnet:3.1-aspnetcore-runtime AS base
EXPOSE 1521
EXPOSE 80
EXPOSE 443
ARG environment
ENV TZ=America/Toronto
ENV ASPNETCORE_ENVIRONMENT=$environment
 
FROM microsoft/dotnet:2.2-sdk AS publish
WORKDIR /transweb-src
COPY . .
## On doit configurer le fuseau horaire pour éviter l'erreur Oracle suivante:
##    ORA-00604: error occurred at recursive SQL level 1 ORA-01882: timezone region not found
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dotnet publish "TransWebWWW/TransWebWWW.csproj" --configuration Release --output /transweb-src/app
 
FROM base AS final
WORKDIR /app
COPY --from=publish /transweb-src/app /app
CMD ["dotnet","TransWebWWW.dll"]