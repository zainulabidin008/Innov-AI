// ignore_for_file: prefer_interpolation_to_compose_strings

import '../models/assistant_model.dart';

String assistantPath = 'assets/icons/ai_assistant/';

List<Map<String, dynamic>> aiAssistantList = [
  {
    'category': 'Writing',
    'types': [
      AssistantModel(
        icon: assistantPath + 'write_ic.png',
        title: 'Write an Articles',
        subTitle: 'Generate well-written articles on any topic you want',
      ),
      AssistantModel(
        icon: assistantPath + 'academic_ic.png',
        title: 'Academic Writer',
        subTitle: 'Generate educational writing such as essays, reports, etc.',
      ),
      AssistantModel(
        icon: assistantPath + 'summarize_ic.png',
        title: 'Summarize (TL;DR)',
        subTitle: 'Extract key points from long texts.',
      ),
      AssistantModel(
        icon: assistantPath + 'translate_ic.png',
        title: 'Translate Language',
        subTitle: 'Translate from one language to another',
      ),
      AssistantModel(
        icon: assistantPath + 'plagiarisam_ic.png',
        title: 'Plagiarisam Check',
        subTitle: 'Check the level of text',
      ),
    ],
  },
  {
    'category': 'Creative',
    'types': [
      AssistantModel(
        icon: assistantPath + 'lyrics_ic.png',
        title: 'Song/lyrics',
        subTitle: 'Generate lyrics from any music genre you want',
      ),
      AssistantModel(
        icon: assistantPath + 'story_teller_ic.png',
        title: 'Storyteller',
        subTitle: 'Generate stories from any given topic',
      ),
      AssistantModel(
        icon: assistantPath + 'poems_ic.png',
        title: 'Poems',
        subTitle: 'Generate poems in different styles',
      ),
      AssistantModel(
        icon: assistantPath + 'movie_ic.png',
        title: 'Movie Script',
        subTitle: 'Generate the script from movie',
      ),
    ],
  },
  {
    'category': 'Business',
    'types': [
      AssistantModel(
        icon: assistantPath + 'email_ic.png',
        title: 'Email Writer',
        subTitle: 'Generate templates for emails, letters, etc.',
      ),
      AssistantModel(
        icon: assistantPath + 'answer_ic.png',
        title: 'Answer Interviewer',
        subTitle: 'Generate Answer to interview questions',
      ),
      AssistantModel(
        icon: assistantPath + 'job_ic.png',
        title: 'Job Post',
        subTitle: 'Write ideal job descriptions for posting.',
      ),
      AssistantModel(
        icon: assistantPath + 'advertisement_ic.png',
        title: 'Advertisement',
        subTitle: 'Generate Promotional text for product,services',
      ),
    ],
  },
  {
    'category': 'Social Media',
    'types': [
      AssistantModel(
        icon: assistantPath + 'linkdin_ic.png',
        title: 'LinkedIn',
        subTitle: 'Create attention grabbing post on linkedIn',
      ),
      AssistantModel(
        icon: assistantPath + 'insta_ic.png',
        title: 'Instagram',
        subTitle: 'Write captions that attract audience on instagram',
      ),
      AssistantModel(
        icon: assistantPath + 'twitter_ic.png',
        title: 'Twitter',
        subTitle: 'Make tweets that catch the attention of readers on',
      ),
      AssistantModel(
        icon: assistantPath + 'fb_ic.png',
        title: 'Facebook',
        subTitle: 'Create attention gra-bbing post on facebook',
      ),
      AssistantModel(
        icon: assistantPath + 'tiktok_ic.png',
        title: 'Tik Tok',
        subTitle: 'Create attention grabbing and viral captions on Tik Tok',
      ),
    ],
  },
  {
    'category': 'Developer',
    'types': [
      AssistantModel(
        icon: assistantPath + 'write_code_ic.png',
        title: 'Write Code',
        subTitle: 'Write codes in any programming language',
      ),
      AssistantModel(
        icon: assistantPath + 'explain_code_ic.png',
        title: 'Explain Code',
        subTitle: 'Explain complicated programming code snippets',
      ),
    ],
  },
  {
    'category': 'Personal',
    'types': [
      AssistantModel(
        icon: assistantPath + 'birthday_ic.png',
        title: 'Birthday',
        subTitle: 'Create sincere birthday wishes for loved ones',
      ),
      AssistantModel(
        icon: assistantPath + 'apology_ic.png',
        title: 'Apology',
        subTitle: 'Make an apology for the mistakes that have been',
      ),
      AssistantModel(
        icon: assistantPath + 'invitation_ic.png',
        title: 'Invitation',
        subTitle: 'Write perfect invitation for any event',
      ),
    ],
  },
  {
    'category': 'Other',
    'types': [
      AssistantModel(
        icon: assistantPath + 'conversation_ic.png',
        title: 'Create Conversation',
        subTitle: 'Create conversation templates for two or...',
      ),
      AssistantModel(
        icon: assistantPath + 'joke_ic.png',
        title: 'tell a Joke',
        subTitle: 'Write funny jokes to tell your friends and make them laugh.',
      ),
      AssistantModel(
        icon: assistantPath + 'food_ic.png',
        title: 'Food Recipes',
        subTitle: 'Get any cooking recipes for food dishes.',
      ),
      AssistantModel(
        icon: assistantPath + 'diet_ic.png',
        title: 'Diet Plan',
        subTitle: 'Create meal plans and diets based on your prefernces',
      ),
    ],
  },
];
