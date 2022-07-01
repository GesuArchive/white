import sys
import os
from pathlib import Path
import torch

input_text = sys.argv[1]
input_speaker = sys.argv[2]

device = torch.device('cpu')
torch.set_num_threads(16)
# speakers = ['aidar', 'baya', 'kseniya', 'xenia', 'eugene']

local_file = 'v3_1_ru.pt'

if not os.path.isfile(local_file):
    torch.hub.download_url_to_file('https://models.silero.ai/models/tts/ru/v3_1_ru.pt', local_file)

model = torch.package.PackageImporter(local_file).load_pickle("tts_models", "model")
model.to(device)

sample_rate = 48000

# Removes dependency on numpy
def tensor_to_int16array(tensor):
	return array.array("h", tensor.to(dtype=torch.int16))

audio_paths = model.save_wav(text = input_text, speaker = input_speaker, sample_rate = sample_rate)

Path(audio_paths[0]).rename(sys.argv[3])
