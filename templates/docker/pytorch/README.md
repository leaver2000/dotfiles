# app

```bash
➜  gpu git:(master) ✗ docker run -it --gpus all nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi
Tue Apr 11 10:41:44 2023
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 530.41.03              Driver Version: 531.41       CUDA Version: 12.1     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                  Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf            Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA GeForce RTX 2080 S...    On | 00000000:01:00.0  On |                  N/A |
|  0%   54C    P0               62W / 250W|   2395MiB /  8192MiB |     11%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+

+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|    0   N/A  N/A        20      G   /Xwayland                                 N/A      |
|    0   N/A  N/A        22      G   /Xwayland                                 N/A      |
|    0   N/A  N/A        33      G   /Xwayland                                 N/A      |
+---------------------------------------------------------------------------------------+
```

```bash
docker-compose up -d
```
