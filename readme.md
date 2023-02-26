# post-install-setup

Script para instalação automatizada de pacotes e dependências para desenvolvimento em instalações limpas de sistemas operacionais Ubuntu. O script contém softwares básicos, linguagens de programação, ferramentas de produtividade, etc.

## O que está incluso

- Linguagens: PHP (via apt), NodeJS (via asdf-vm) e Ruby (via asdf-vm)
- Bancos de Dados: SQLite, MySQL
- Ferramentas: curl, git, wget, ffmpeg, openssl, asdf-vm
- Programas: OBS Studio (deb), Chromium (snap), Discord (snap), Postman (snap)
- Terminal: zsh e oh-my-zsh, powerlevel10k, syntax-highlight, autosuggestions, k
- Jogos: ares (emulador multi-sistema)

## Como usar

1. Baixe o repoistório (ou clone-o) e extraia o conteúdo.
2. Abra o terminal no diretório do arquivo e execute-o:
```sh
./initial_setup_ubuntu.sh
```
3. Informe a senha quando for pedido.
4. Após a instalação do zsh ele irá ser executado e perguntar sobre os arquivos de configuração. Escolha a opção **2** para criar os arquivos padrão.
5. Ao instalar o oh-my-zsh ele pode perguntar se deseja mudar o terminal padrão do sistema para o zsh. Escolha **Y** para confirmar.
6. Depois executar o script reinicie o sistema:
```sh
shutdown -r now
```
7. Depois de reiniar, abra novamente o terminal. Ele deverá mostrar as perguntas para a personalização inicial do tema powerlevel10k.
8. Ignore o terminal por enquanto. Acesse as **"Preferências"** do terminal, escolha um perfil (por exemplo, **"Sem nome"**) e altere a fonte para **"MesloLGS Nerd Font"**.
![Captura de tela de 2023-02-26 14-38-42](https://user-images.githubusercontent.com/43050548/221427403-87372420-4748-4b48-b3ca-ff9da8e7af22.png)
9. Siga as intruções de configuração do tema respondendo de acordo com as suas preferências.
10. Tudo pronto! 😁

## Como customizar

Se você desejar incluir ou remover algum pacotes na instalação basta abrir o arquivo com um editor de texto e comentar/acrescentar os pacotes que desejar nas variáveis adequadas. Pacotes .deb instalados via apt ficam na variável APT_PACKAGES e pacotes snap na SNAP_PACKAGES.

Agradecimento especial ao [@Diolinux](https://github.com/Diolinux) 🙂 (inspirado no [pop-os-postinstall](https://github.com/Diolinux/pop-os-postinstall))
