import 'package:ai_voice_assistant/pallete.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'feature_box.dart';
import 'openai_service.dart';




class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final speechToText = SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAiService openAiService = OpenAiService();
  String? generatedContent;
  String? generatedimageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async{
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async{
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future <void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future <void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async{
    await flutterTts.speak(content);
  }

  @override
  void dispose(){
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text('Evie')),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body:  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/virtualAssistant.png',
                          ),
                        )
                    ),
                  )
                ],
              ),
            ),
            // Chat bubble
            FadeInRight(
              child: Visibility(
                visible: generatedimageUrl == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(border: Border.all(
                      color: Pallete.borderColor
                  ),
                      borderRadius: BorderRadius.circular(20).copyWith(
                          topLeft: Radius.zero
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      generatedContent == null
                          ? "Good Morning , what task can I do for you?"
                          : generatedContent!,
                      style: TextStyle(
                          color: Pallete.mainFontColor,
                          fontSize: generatedContent == null ? 25 : 18,
                          fontFamily: 'CeraPro'
                      ),),
                  ),
                ),
              ),
            ),

            if(generatedimageUrl != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(generatedimageUrl!)),
              ),

            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedimageUrl == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                      top: 10,
                      left: 20
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text('Here are a few features',style: TextStyle(
                      fontFamily:'CeraPro',
                      fontWeight: FontWeight.bold,
                      color: Pallete.mainFontColor
                  ),),
                ),
              ),
            ),
            //Featurrs list

            Visibility(
              visible: generatedContent == null && generatedimageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const FeatureBox(color: Pallete.firstSuggestionBoxColor,
                      headerText: 'ChatGPT',
                      desc: 'A smarter way to stay organized and informed with ChatGPT',
                    ),
                  ),

                  SlideInLeft(
                    delay: Duration(microseconds: start + 2*delay),
                    child: const FeatureBox(color: Pallete.secondSuggestionBoxColor,
                      headerText: 'Dall-E',
                      desc: 'Get inspired and stay creative with your personal assistant powered by Dall-E',
                    ),
                  ),

                  SlideInLeft(
                    delay: Duration(microseconds: start + delay),
                    child: const FeatureBox(color: Pallete.thirdSuggestionBoxColor,
                      headerText: 'Smart Voice Assistant',
                      desc: 'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                    ),
                  ),
                  const SizedBox(height: 30,)
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(microseconds: start + 3*delay),
        child: FloatingActionButton(
          onPressed: ()async{
            if(await speechToText.hasPermission && speechToText.isNotListening){
              await startListening();
            }else if(speechToText.isListening){
              final speech = await openAiService.isArtPromptAPI(lastWords);
              if(speech.contains('https')){
                generatedimageUrl = speech;
                generatedContent = null;
                setState(() {});
              }else{
                generatedimageUrl = null;
                generatedContent = speech;
                setState(() {});
                await systemSpeak(speech);
              }


              await stopListening();
            }else{
              initSpeechToText();
            }
          },
          backgroundColor: Pallete.firstSuggestionBoxColor,
          child: Icon( speechToText.isListening ? Icons.stop : Icons.mic),),
      ),
    );
  }
}
