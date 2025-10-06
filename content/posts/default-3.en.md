---
title: Test post
date: 2025-10-05
draft: false
tags:
 - init
 - blog
---

# Testing GPU in VM with Hyper-V

Today I decided to run a quick test in my virtualization environment using **Hyper-V**.
The idea was to see how the GPU would appear inside a Linux VM when **Enhanced Session Mode** is enabled.

I ran the command:

```bash
garuda-inxi
```

And to my surprise, the message appeared:

> **no PCI devices found**

This happens because, with Enhanced Session, the video card **is not passed through as a real PCI device** to the VM.
Instead, Hyper-V creates a **virtual video adapter** that uses the host GPU’s resources in a shared way.
That’s why tools like `inxi` or `lspci` cannot list the physical GPU.

---

## When to use GPU passthrough

If the goal were to use the GPU directly (with real passthrough), it would be necessary to configure **DDA (Discrete Device Assignment)** or switch to another hypervisor, such as **Proxmox** or **VMware**, which offer more complete support for this type of usage.

---

## Conclusion

For light graphical tasks, the current mode already works fine.
This was just a test, but it was enough to better understand how Hyper-V handles **graphics acceleration in Linux VMs**.
