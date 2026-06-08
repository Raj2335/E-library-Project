Deploying to Render (quick container path)

1. Build the WAR locally:

```powershell
mvn -DskipTests package
```

2. Build the Docker image (from repo root):

```powershell
# make sure target/elibrary.war exists
docker build -t elibrary:latest .
```

3. Test locally:

```powershell
docker run --rm -p 8080:8080 elibrary:latest
# then open http://localhost:8080/elibrary/
```

4. Push to Docker Hub (or a registry):

```powershell
docker tag elibrary:latest yourdockerhubuser/elibrary:latest
docker push yourdockerhubuser/elibrary:latest
```

5. Create a new Render Web Service using "Docker" or connect via GitHub and Render will build from the Dockerfile.

Notes:

- Alternatively use Fly.io or Azure App Service for Containers with the same Dockerfile.
- If you prefer, I can try to build the Docker image here and/or push it if you provide registry credentials.
