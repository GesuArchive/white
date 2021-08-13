import sys
import os
from pathlib import Path
import torch
import random

device = torch.device('cpu')
torch.set_num_threads(16)
local_file = 'model_multi.pt'
speakers = ['aidar', 'baya', 'kseniya', 'natasha']

if not os.path.isfile(local_file):
    torch.hub.download_url_to_file('https://models.silero.ai/models/tts/multi/v2_multi.pt', local_file)

model = torch.package.PackageImporter(local_file).load_pickle("tts_models", "model")
model.to(device)

sample_rate = 16000

audio_paths = model.save_wav(texts=sys.argv[1], speakers=sys.argv[2], sample_rate=sample_rate)

Path(audio_paths[0]).rename(sys.argv[3])
