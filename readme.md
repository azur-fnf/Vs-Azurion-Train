# Friday Night Funkin's
## Mod By Azurion (azurion_under) / (azuriondev)

### For me i am dumb and i don't know how upload in github



## How to run


Depois é só adicionar, commitar e dar push:

```bash
git add README.md
git commit -m "Add README.md in English"
git push origin main
````


## 🔹 2. Criar um `.gitignore`

O `.gitignore` serve pra dizer ao Git **quais arquivos ou pastas não devem ser versionados**.

### Exemplo básico para um projeto FNF/HaxeFlixel:

```gitignore
# Haxe build folders
/bin/
/export/
/obj/

# Temporary files
*.tmp
*.log

# OS files
.DS_Store
Thumbs.db
```

---

### 🔹 Ignorar arquivos ou pastas específicas

* **Pasta inteira:**

  ```gitignore
  assets/data/old_songs/
  ```
* **Arquivos específicos:**

  ```gitignore
  secret.txt
  *.mp3
  ```
* **Arquivos por extensão:**

  ```gitignore
  *.exe
  *.swp
  ```

Depois de criar o `.gitignore`, adicione, commite e dê push:

```bash
git add .gitignore
git commit -m "Add .gitignore"
git push origin main
```
