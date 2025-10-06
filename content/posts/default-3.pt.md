---
title: Git init
date: 2025-10-05
draft: false
tags:
  - init
  - blog
---

# Testando GPU em VM com Hyper-V

Hoje resolvi fazer um teste rápido no meu ambiente de virtualização usando o **Hyper-V**.
A ideia era ver como a GPU aparecia dentro de uma VM Linux quando o **Enhanced Session Mode** está habilitado.

Rodei o comando:

```bash
garuda-inxi
```

E para minha surpresa, apareceu a mensagem:

> **no PCI devices found**

Isso acontece porque, com o Enhanced Session, a placa de vídeo **não é passada como um dispositivo PCI real** para a VM.
Em vez disso, o Hyper-V cria um **adaptador de vídeo virtual** que usa os recursos da GPU do host de forma compartilhada.
Por isso, ferramentas como `inxi` ou `lspci` não conseguem listar a placa física.

---

## Quando usar passthrough de GPU

Se o objetivo fosse usar a GPU de forma direta (com passthrough real), seria necessário configurar o **DDA (Discrete Device Assignment)** ou partir para outro hypervisor, como **Proxmox** ou **VMware**, que oferecem suporte mais completo para esse tipo de uso.

---

## Conclusão

Para tarefas gráficas leves, o modo atual já funciona bem.
Esse foi só um teste, mas já deu para entender melhor como o Hyper-V lida com **aceleração gráfica em VMs Linux**.

