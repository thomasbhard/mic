# Musical Instrument Classifier (MIC)

Mobile app for the musical instrument classifier developed by Lukas Flatz and Thomas Bernhard.


## What you need to know
- CHECK LICENCE FOR INSTRUMENT ICONS
- Due to the absence of a tflite package for flutter that allows to use custom models the classification is written in java. Therefore the app currently only works on android. But once flutter supports custom tflite models only one function call has to be switched to be truly cross-platform.

- **DO NOT** get crazy with uploading new training data to the database. Firbase only allows 1GiB in their free [Spark](https://firebase.google.com/pricing) mode.

## Related work
### Feature Extraction
For training new models you can take a look at [this](https://github.com/thomasbhard/irmas-features) tool to extract features from the [IRMAS Dataset](https://www.upf.edu/web/mtg/irmas).

### Retraining

If you want to retreive data form the database to retrain models with data collected from the app, follow [this python notebook](https://github.com/thomasbhard/mic-model-retraining).

