import 'package:go_router/go_router.dart';
import 'package:soulchat/features/accounting/screens/accounting_screen.dart';
import 'package:soulchat/features/age_calculator/screens/age_calculator_screen.dart';
import 'package:soulchat/features/alarm_clock/screens/alarm_clock_screen.dart';
import 'package:soulchat/features/animation_studio/screens/animation_studio_screen.dart';
import 'package:soulchat/features/appliance_manager/screens/appliance_manager_screen.dart';
import 'package:soulchat/features/ar_filters/screens/ar_filters_screen.dart';
import 'package:soulchat/features/auction/screens/auction_screen.dart';
import 'package:soulchat/features/automotive/screens/automotive_screen.dart';
import 'package:soulchat/features/avatar_creator/screens/avatar_creator_screen.dart';
import 'package:soulchat/features/baby_tracker/screens/baby_tracker_screen.dart';
import 'package:soulchat/features/backup_restore/screens/backup_restore_screen.dart';
import 'package:soulchat/features/banner_designer/screens/banner_designer_screen.dart';
import 'package:soulchat/features/barcode_scanner/screens/barcode_scanner_screen.dart';
import 'package:soulchat/features/beauty_tips/screens/beauty_tips_screen.dart';
import 'package:soulchat/features/betting/screens/betting_screen.dart';
import 'package:soulchat/features/blog/screens/blog_screen.dart';
import 'package:soulchat/features/bmi_calculator/screens/bmi_calculator_screen.dart';
import 'package:soulchat/features/book_reader/screens/book_reader_screen.dart';
import 'package:soulchat/features/bookmarks/screens/bookmarks_screen.dart';
import 'package:soulchat/features/browser/screens/browser_screen.dart';
import 'package:soulchat/features/budget_planner/screens/budget_planner_screen.dart';
import 'package:soulchat/features/business_cards/screens/business_cards_screen.dart';
import 'package:soulchat/features/calendar/screens/calendar_screen.dart';
import 'package:soulchat/features/calorie_counter/screens/calorie_counter_screen.dart';
import 'package:soulchat/features/camping_guide/screens/camping_guide_screen.dart';
import 'package:soulchat/features/car_rental/screens/car_rental_screen.dart';
import 'package:soulchat/features/casino/screens/casino_screen.dart';
import 'package:soulchat/features/charity/screens/charity_screen.dart';
import 'package:soulchat/features/cloud_storage/screens/cloud_storage_screen.dart';
import 'package:soulchat/features/code_collaboration/screens/code_collaboration_screen.dart';
import 'package:soulchat/features/collage_maker/screens/collage_maker_screen.dart';
import 'package:soulchat/features/color_picker/screens/color_picker_screen.dart';
import 'package:soulchat/features/comic_creator/screens/comic_creator_screen.dart';
import 'package:soulchat/features/community_service/screens/community_service_screen.dart';
import 'package:soulchat/features/concert_tickets/screens/concert_tickets_screen.dart';
import 'package:soulchat/features/contact_manager/screens/contact_manager_screen.dart';
import 'package:soulchat/features/contests/screens/contests_screen.dart';
import 'package:soulchat/features/countdown_timer/screens/countdown_timer_screen.dart';
import 'package:soulchat/features/coupons/screens/coupons_screen.dart';
import 'package:soulchat/features/crm_system/screens/crm_system_screen.dart';
import 'package:soulchat/features/crypto_trading/screens/crypto_trading_screen.dart';
import 'package:soulchat/features/currency_converter/screens/currency_converter_screen.dart';
import 'package:soulchat/features/cycling_tracker/screens/cycling_tracker_screen.dart';
import 'package:soulchat/features/daily_missions/screens/daily_missions_screen.dart';
import 'package:soulchat/features/dating/screens/dating_screen.dart';
import 'package:soulchat/features/design_workspace/screens/design_workspace_screen.dart';
import 'package:soulchat/features/diagram/screens/diagram_screen.dart';
import 'package:soulchat/features/discount_finder/screens/discount_finder_screen.dart';
import 'package:soulchat/features/document_scanner/screens/document_scanner_screen.dart';
import 'package:soulchat/features/donations/screens/donations_screen.dart';
import 'package:soulchat/features/elderly_care/screens/elderly_care_screen.dart';
import 'package:soulchat/features/email/screens/email_screen.dart';
import 'package:soulchat/features/emergency_sos/screens/emergency_sos_screen.dart';
import 'package:soulchat/features/expense_tracker/screens/expense_tracker_screen.dart';
import 'package:soulchat/features/family_organizer/screens/family_organizer_screen.dart';
import 'package:soulchat/features/fashion_assistant/screens/fashion_assistant_screen.dart';
import 'package:soulchat/features/file_manager/screens/file_manager_screen.dart';
import 'package:soulchat/features/first_aid/screens/first_aid_screen.dart';
import 'package:soulchat/features/fitness/screens/fitness_screen.dart';
import 'package:soulchat/features/flashlight_compass/screens/flashlight_compass_screen.dart';
import 'package:soulchat/features/flight_booking/screens/flight_booking_screen.dart';
import 'package:soulchat/features/flowchart/screens/flowchart_screen.dart';
import 'package:soulchat/features/font_manager/screens/font_manager_screen.dart';
import 'package:soulchat/features/food/screens/food_screen.dart';
import 'package:soulchat/features/freelance_marketplace/screens/freelance_marketplace_screen.dart';
import 'package:soulchat/features/fundraising/screens/fundraising_screen.dart';
import 'package:soulchat/features/garden_planner/screens/garden_planner_screen.dart';
import 'package:soulchat/features/gif_maker/screens/gif_maker_screen.dart';
import 'package:soulchat/features/gift_cards/screens/gift_cards_screen.dart';
import 'package:soulchat/features/goal_tracker/screens/goal_tracker_screen.dart';
import 'package:soulchat/features/gym_finder/screens/gym_finder_screen.dart';
import 'package:soulchat/features/habit_tracker/screens/habit_tracker_screen.dart';
import 'package:soulchat/features/hiking_trails/screens/hiking_trails_screen.dart';
import 'package:soulchat/features/home_services/screens/home_services_screen.dart';
import 'package:soulchat/features/hotel_booking/screens/hotel_booking_screen.dart';
import 'package:soulchat/features/icon_library/screens/icon_library_screen.dart';
import 'package:soulchat/features/insurance/screens/insurance_screen.dart';
import 'package:soulchat/features/interior_design/screens/interior_design_screen.dart';
import 'package:soulchat/features/invoice_manager/screens/invoice_manager_screen.dart';
import 'package:soulchat/features/itinerary/screens/itinerary_screen.dart';
import 'package:soulchat/features/job_board/screens/job_board_screen.dart';
import 'package:soulchat/features/kids_activities/screens/kids_activities_screen.dart';
import 'package:soulchat/features/language_learning/screens/language_learning_screen.dart';
import 'package:soulchat/features/leaderboard_global/screens/leaderboard_global_screen.dart';
import 'package:soulchat/features/legal_advisor/screens/legal_advisor_screen.dart';
import 'package:soulchat/features/loan_calculator/screens/loan_calculator_screen.dart';
import 'package:soulchat/features/location_tracker/screens/location_tracker_screen.dart';
import 'package:soulchat/features/logo_maker/screens/logo_maker_screen.dart';
import 'package:soulchat/features/lottery/screens/lottery_screen.dart';
import 'package:soulchat/features/macro_tracker/screens/macro_tracker_screen.dart';
import 'package:soulchat/features/maintenance_tracker/screens/maintenance_tracker_screen.dart';
import 'package:soulchat/features/maps/screens/maps_screen.dart';
import 'package:soulchat/features/media_player/screens/media_player_screen.dart';
import 'package:soulchat/features/meditation/screens/meditation_screen.dart';
import 'package:soulchat/features/meeting_scheduler/screens/meeting_scheduler_screen.dart';
import 'package:soulchat/features/meme_generator/screens/meme_generator_screen.dart';
import 'package:soulchat/features/mind_map/screens/mind_map_screen.dart';
import 'package:soulchat/features/monthly_events/screens/monthly_events_screen.dart';
import 'package:soulchat/features/movie_finder/screens/movie_finder_screen.dart';
import 'package:soulchat/features/music_discovery/screens/music_discovery_screen.dart';
import 'package:soulchat/features/music_recording/screens/music_recording_screen.dart';
import 'package:soulchat/features/news/screens/news_screen.dart';
import 'package:soulchat/features/nft_marketplace/screens/nft_marketplace_screen.dart';
import 'package:soulchat/features/notes/screens/notes_screen.dart';
import 'package:soulchat/features/nutrition_guide/screens/nutrition_guide_screen.dart';
import 'package:soulchat/features/outdoor_activities/screens/outdoor_activities_screen.dart';
import 'package:soulchat/features/parenting/screens/parenting_screen.dart';
import 'package:soulchat/features/password_manager/screens/password_manager_screen.dart';
import 'package:soulchat/features/personal_trainer/screens/personal_trainer_screen.dart';
import 'package:soulchat/features/pet_care/screens/pet_care_screen.dart';
import 'package:soulchat/features/petitions/screens/petitions_screen.dart';
import 'package:soulchat/features/photo_gallery/screens/photo_gallery_screen.dart';
import 'package:soulchat/features/podcast/screens/podcast_screen.dart';
import 'package:soulchat/features/polls/screens/polls_screen.dart';
import 'package:soulchat/features/pomodoro/screens/pomodoro_screen.dart';
import 'package:soulchat/features/presentation/screens/presentation_screen.dart';
import 'package:soulchat/features/price_comparison/screens/price_comparison_screen.dart';
import 'package:soulchat/features/project_manager/screens/project_manager_screen.dart';
import 'package:soulchat/features/qr_scanner/screens/qr_scanner_screen.dart';
import 'package:soulchat/features/quiz/screens/quiz_screen.dart';
import 'package:soulchat/features/radio/screens/radio_screen.dart';
import 'package:soulchat/features/ratings/screens/ratings_screen.dart';
import 'package:soulchat/features/real_estate/screens/real_estate_screen.dart';
import 'package:soulchat/features/recipe_book/screens/recipe_book_screen.dart';
import 'package:soulchat/features/referral_system/screens/referral_system_screen.dart';
import 'package:soulchat/features/resume_builder/screens/resume_builder_screen.dart';
import 'package:soulchat/features/reviews/screens/reviews_screen.dart';
import 'package:soulchat/features/ringtone_maker/screens/ringtone_maker_screen.dart';
import 'package:soulchat/features/running_tracker/screens/running_tracker_screen.dart';
import 'package:soulchat/features/scratch_cards/screens/scratch_cards_screen.dart';
import 'package:soulchat/features/screen_recorder/screens/screen_recorder_screen.dart';
import 'package:soulchat/features/screen_sharing/screens/screen_sharing_screen.dart';
import 'package:soulchat/features/screenshot_editor/screens/screenshot_editor_screen.dart';
import 'package:soulchat/features/shopping/screens/shopping_screen.dart';
import 'package:soulchat/features/sleep_tracker/screens/sleep_tracker_screen.dart';
import 'package:soulchat/features/smart_home/screens/smart_home_screen.dart';
import 'package:soulchat/features/social_feed/screens/social_feed_screen.dart';
import 'package:soulchat/features/sound_effects/screens/sound_effects_screen.dart';
import 'package:soulchat/features/spin_wheel/screens/spin_wheel_screen.dart';
import 'package:soulchat/features/sports_finder/screens/sports_finder_screen.dart';
import 'package:soulchat/features/sticker_store/screens/sticker_store_screen.dart';
import 'package:soulchat/features/stock_market/screens/stock_market_screen.dart';
import 'package:soulchat/features/stopwatch/screens/stopwatch_screen.dart';
import 'package:soulchat/features/surveys/screens/surveys_screen.dart';
import 'package:soulchat/features/swimming_tracker/screens/swimming_tracker_screen.dart';
import 'package:soulchat/features/task_manager/screens/task_manager_screen.dart';
import 'package:soulchat/features/tax_calculator/screens/tax_calculator_screen.dart';
import 'package:soulchat/features/team_collaboration/screens/team_collaboration_screen.dart';
import 'package:soulchat/features/testimonials/screens/testimonials_screen.dart';
import 'package:soulchat/features/theatre_shows/screens/theatre_shows_screen.dart';
import 'package:soulchat/features/theme_store/screens/theme_store_screen.dart';
import 'package:soulchat/features/time_tracker/screens/time_tracker_screen.dart';
import 'package:soulchat/features/translator/screens/translator_screen.dart';
import 'package:soulchat/features/travel_planner/screens/travel_planner_screen.dart';
import 'package:soulchat/features/tv_streaming/screens/tv_streaming_screen.dart';
import 'package:soulchat/features/unit_converter/screens/unit_converter_screen.dart';
import 'package:soulchat/features/video_call/screens/video_call_screen.dart';
import 'package:soulchat/features/video_conference/screens/video_conference_screen.dart';
import 'package:soulchat/features/video_recording/screens/video_recording_screen.dart';
import 'package:soulchat/features/visa_guide/screens/visa_guide_screen.dart';
import 'package:soulchat/features/voice_translator/screens/voice_translator_screen.dart';
import 'package:soulchat/features/volunteering/screens/volunteering_screen.dart';
import 'package:soulchat/features/voting/screens/voting_screen.dart';
import 'package:soulchat/features/vouchers/screens/vouchers_screen.dart';
import 'package:soulchat/features/vpn/screens/vpn_screen.dart';
import 'package:soulchat/features/water_reminder/screens/water_reminder_screen.dart';
import 'package:soulchat/features/weather/screens/weather_screen.dart';
import 'package:soulchat/features/weekly_challenges/screens/weekly_challenges_screen.dart';
import 'package:soulchat/features/whiteboard/screens/whiteboard_screen.dart';
import 'package:soulchat/features/wiki/screens/wiki_screen.dart';
import 'package:soulchat/features/wishlist/screens/wishlist_screen.dart';
import 'package:soulchat/features/workout_planner/screens/workout_planner_screen.dart';
import 'package:soulchat/features/world_clock/screens/world_clock_screen.dart';
import 'package:soulchat/features/yoga_instructor/screens/yoga_instructor_screen.dart';

List<GoRoute> get extraRoutes => [
  GoRoute(path: '/accounting', name: 'accounting', builder: (c,s) => const AccountingScreen()),
  GoRoute(path: '/age-calculator', name: 'age_calculator', builder: (c,s) => const AgeCalculatorScreen()),
  GoRoute(path: '/alarm-clock', name: 'alarm_clock', builder: (c,s) => const AlarmClockScreen()),
  GoRoute(path: '/animation-studio', name: 'animation_studio', builder: (c,s) => const AnimationStudioScreen()),
  GoRoute(path: '/appliance-manager', name: 'appliance_manager', builder: (c,s) => const ApplianceManagerScreen()),
  GoRoute(path: '/ar-filters', name: 'ar_filters', builder: (c,s) => const ARFiltersScreen()),
  GoRoute(path: '/auction', name: 'auction', builder: (c,s) => const AuctionScreen()),
  GoRoute(path: '/automotive', name: 'automotive', builder: (c,s) => const AutomotiveScreen()),
  GoRoute(path: '/avatar-creator', name: 'avatar_creator', builder: (c,s) => const AvatarCreatorScreen()),
  GoRoute(path: '/baby-tracker', name: 'baby_tracker', builder: (c,s) => const BabyTrackerScreen()),
  GoRoute(path: '/backup-restore', name: 'backup_restore', builder: (c,s) => const BackupRestoreScreen()),
  GoRoute(path: '/banner-designer', name: 'banner_designer', builder: (c,s) => const BannerDesignerScreen()),
  GoRoute(path: '/barcode-scanner', name: 'barcode_scanner', builder: (c,s) => const BarcodeScannerScreen()),
  GoRoute(path: '/beauty-tips', name: 'beauty_tips', builder: (c,s) => const BeautyTipsScreen()),
  GoRoute(path: '/betting', name: 'betting', builder: (c,s) => const BettingScreen()),
  GoRoute(path: '/blog', name: 'blog', builder: (c,s) => const BlogScreen()),
  GoRoute(path: '/bmi-calculator', name: 'bmi_calculator', builder: (c,s) => const BmiCalculatorScreen()),
  GoRoute(path: '/book-reader', name: 'book_reader', builder: (c,s) => const BookReaderScreen()),
  GoRoute(path: '/bookmarks', name: 'bookmarks', builder: (c,s) => const BookmarksScreen()),
  GoRoute(path: '/browser', name: 'browser', builder: (c,s) => const BrowserScreen()),
  GoRoute(path: '/budget-planner', name: 'budget_planner', builder: (c,s) => const BudgetPlannerScreen()),
  GoRoute(path: '/business-cards', name: 'business_cards', builder: (c,s) => const BusinessCardsScreen()),
  GoRoute(path: '/calendar', name: 'calendar', builder: (c,s) => const CalendarScreen()),
  GoRoute(path: '/calorie-counter', name: 'calorie_counter', builder: (c,s) => const CalorieCounterScreen()),
  GoRoute(path: '/camping-guide', name: 'camping_guide', builder: (c,s) => const CampingGuideScreen()),
  GoRoute(path: '/car-rental', name: 'car_rental', builder: (c,s) => const CarRentalScreen()),
  GoRoute(path: '/casino', name: 'casino', builder: (c,s) => const CasinoScreen()),
  GoRoute(path: '/charity', name: 'charity', builder: (c,s) => const CharityScreen()),
  GoRoute(path: '/cloud-storage', name: 'cloud_storage', builder: (c,s) => const CloudStorageScreen()),
  GoRoute(path: '/code-collaboration', name: 'code_collaboration', builder: (c,s) => const CodeCollaborationScreen()),
  GoRoute(path: '/collage-maker', name: 'collage_maker', builder: (c,s) => const CollageMakerScreen()),
  GoRoute(path: '/color-picker', name: 'color_picker', builder: (c,s) => const ColorPickerScreen()),
  GoRoute(path: '/comic-creator', name: 'comic_creator', builder: (c,s) => const ComicCreatorScreen()),
  GoRoute(path: '/community-service', name: 'community_service', builder: (c,s) => const Community_serviceScreen()),
  GoRoute(path: '/concert-tickets', name: 'concert_tickets', builder: (c,s) => const ConcertTicketsScreen()),
  GoRoute(path: '/contact-manager', name: 'contact_manager', builder: (c,s) => const ContactManagerScreen()),
  GoRoute(path: '/contests', name: 'contests', builder: (c,s) => const ContestsScreen()),
  GoRoute(path: '/countdown-timer', name: 'countdown_timer', builder: (c,s) => const CountdownTimerScreen()),
  GoRoute(path: '/coupons', name: 'coupons', builder: (c,s) => const CouponsScreen()),
  GoRoute(path: '/crm-system', name: 'crm_system', builder: (c,s) => const CrmSystemScreen()),
  GoRoute(path: '/crypto-trading', name: 'crypto_trading', builder: (c,s) => const CryptoTradingScreen()),
  GoRoute(path: '/currency-converter', name: 'currency_converter', builder: (c,s) => const CurrencyConverterScreen()),
  GoRoute(path: '/cycling-tracker', name: 'cycling_tracker', builder: (c,s) => const CyclingTrackerScreen()),
  GoRoute(path: '/daily-missions', name: 'daily_missions', builder: (c,s) => const Daily_missionsScreen()),
  GoRoute(path: '/dating', name: 'dating', builder: (c,s) => const DatingScreen()),
  GoRoute(path: '/design-workspace', name: 'design_workspace', builder: (c,s) => const DesignWorkspaceScreen()),
  GoRoute(path: '/diagram', name: 'diagram', builder: (c,s) => const DiagramScreen()),
  GoRoute(path: '/discount-finder', name: 'discount_finder', builder: (c,s) => const Discount_finderScreen()),
  GoRoute(path: '/document-scanner', name: 'document_scanner', builder: (c,s) => const DocumentScannerScreen()),
  GoRoute(path: '/donations', name: 'donations', builder: (c,s) => const DonationsScreen()),
  GoRoute(path: '/elderly-care', name: 'elderly_care', builder: (c,s) => const ElderlyCareScreen()),
  GoRoute(path: '/email', name: 'email', builder: (c,s) => const EmailScreen()),
  GoRoute(path: '/emergency-sos', name: 'emergency_sos', builder: (c,s) => const EmergencySosScreen()),
  GoRoute(path: '/expense-tracker', name: 'expense_tracker', builder: (c,s) => const ExpenseTrackerScreen()),
  GoRoute(path: '/family-organizer', name: 'family_organizer', builder: (c,s) => const FamilyOrganizerScreen()),
  GoRoute(path: '/fashion-assistant', name: 'fashion_assistant', builder: (c,s) => const FashionAssistantScreen()),
  GoRoute(path: '/file-manager', name: 'file_manager', builder: (c,s) => const FileManagerScreen()),
  GoRoute(path: '/first-aid', name: 'first_aid', builder: (c,s) => const FirstAidScreen()),
  GoRoute(path: '/fitness', name: 'fitness', builder: (c,s) => const FitnessScreen()),
  GoRoute(path: '/flashlight-compass', name: 'flashlight_compass', builder: (c,s) => const FlashlightCompassScreen()),
  GoRoute(path: '/flight-booking', name: 'flight_booking', builder: (c,s) => const FlightBookingScreen()),
  GoRoute(path: '/flowchart', name: 'flowchart', builder: (c,s) => const FlowchartScreen()),
  GoRoute(path: '/font-manager', name: 'font_manager', builder: (c,s) => const FontManagerScreen()),
  GoRoute(path: '/food', name: 'food', builder: (c,s) => const FoodScreen()),
  GoRoute(path: '/freelance-marketplace', name: 'freelance_marketplace', builder: (c,s) => const FreelanceMarketplaceScreen()),
  GoRoute(path: '/fundraising', name: 'fundraising', builder: (c,s) => const FundraisingScreen()),
  GoRoute(path: '/garden-planner', name: 'garden_planner', builder: (c,s) => const GardenPlannerScreen()),
  GoRoute(path: '/gif-maker', name: 'gif_maker', builder: (c,s) => const GifMakerScreen()),
  GoRoute(path: '/gift-cards', name: 'gift_cards', builder: (c,s) => const Gift_cardsScreen()),
  GoRoute(path: '/goal-tracker', name: 'goal_tracker', builder: (c,s) => const GoalTrackerScreen()),
  GoRoute(path: '/gym-finder', name: 'gym_finder', builder: (c,s) => const GymFinderScreen()),
  GoRoute(path: '/habit-tracker', name: 'habit_tracker', builder: (c,s) => const HabitTrackerScreen()),
  GoRoute(path: '/hiking-trails', name: 'hiking_trails', builder: (c,s) => const HikingTrailsScreen()),
  GoRoute(path: '/home-services', name: 'home_services', builder: (c,s) => const HomeServicesScreen()),
  GoRoute(path: '/hotel-booking', name: 'hotel_booking', builder: (c,s) => const HotelBookingScreen()),
  GoRoute(path: '/icon-library', name: 'icon_library', builder: (c,s) => const IconLibraryScreen()),
  GoRoute(path: '/insurance', name: 'insurance', builder: (c,s) => const InsuranceScreen()),
  GoRoute(path: '/interior-design', name: 'interior_design', builder: (c,s) => const InteriorDesignScreen()),
  GoRoute(path: '/invoice-manager', name: 'invoice_manager', builder: (c,s) => const InvoiceManagerScreen()),
  GoRoute(path: '/itinerary', name: 'itinerary', builder: (c,s) => const ItineraryScreen()),
  GoRoute(path: '/job-board', name: 'job_board', builder: (c,s) => const JobBoardScreen()),
  GoRoute(path: '/kids-activities', name: 'kids_activities', builder: (c,s) => const KidsActivitiesScreen()),
  GoRoute(path: '/language-learning', name: 'language_learning', builder: (c,s) => const LanguageLearningScreen()),
  GoRoute(path: '/leaderboard-global', name: 'leaderboard_global', builder: (c,s) => const LeaderboardGlobalScreen()),
  GoRoute(path: '/legal-advisor', name: 'legal_advisor', builder: (c,s) => const LegalAdvisorScreen()),
  GoRoute(path: '/loan-calculator', name: 'loan_calculator', builder: (c,s) => const LoanCalculatorScreen()),
  GoRoute(path: '/location-tracker', name: 'location_tracker', builder: (c,s) => const LocationTrackerScreen()),
  GoRoute(path: '/logo-maker', name: 'logo_maker', builder: (c,s) => const LogoMakerScreen()),
  GoRoute(path: '/lottery', name: 'lottery', builder: (c,s) => const LotteryScreen()),
  GoRoute(path: '/macro-tracker', name: 'macro_tracker', builder: (c,s) => const MacroTrackerScreen()),
  GoRoute(path: '/maintenance-tracker', name: 'maintenance_tracker', builder: (c,s) => const MaintenanceTrackerScreen()),
  GoRoute(path: '/maps', name: 'maps', builder: (c,s) => const MapsScreen()),
  GoRoute(path: '/media-player', name: 'media_player', builder: (c,s) => const MediaPlayerScreen()),
  GoRoute(path: '/meditation', name: 'meditation', builder: (c,s) => const MeditationScreen()),
  GoRoute(path: '/meeting-scheduler', name: 'meeting_scheduler', builder: (c,s) => const MeetingSchedulerScreen()),
  GoRoute(path: '/meme-generator', name: 'meme_generator', builder: (c,s) => const MemeGeneratorScreen()),
  GoRoute(path: '/mind-map', name: 'mind_map', builder: (c,s) => const MindMapScreen()),
  GoRoute(path: '/monthly-events', name: 'monthly_events', builder: (c,s) => const Monthly_eventsScreen()),
  GoRoute(path: '/movie-finder', name: 'movie_finder', builder: (c,s) => const MovieFinderScreen()),
  GoRoute(path: '/music-discovery', name: 'music_discovery', builder: (c,s) => const MusicDiscoveryScreen()),
  GoRoute(path: '/music-recording', name: 'music_recording', builder: (c,s) => const MusicRecordingScreen()),
  GoRoute(path: '/news', name: 'news', builder: (c,s) => const NewsScreen()),
  GoRoute(path: '/nft-marketplace', name: 'nft_marketplace', builder: (c,s) => const NFTMarketplaceScreen()),
  GoRoute(path: '/notes', name: 'notes', builder: (c,s) => const NotesScreen()),
  GoRoute(path: '/nutrition-guide', name: 'nutrition_guide', builder: (c,s) => const NutritionGuideScreen()),
  GoRoute(path: '/outdoor-activities', name: 'outdoor_activities', builder: (c,s) => const OutdoorActivitiesScreen()),
  GoRoute(path: '/parenting', name: 'parenting', builder: (c,s) => const ParentingScreen()),
  GoRoute(path: '/password-manager', name: 'password_manager', builder: (c,s) => const PasswordManagerScreen()),
  GoRoute(path: '/personal-trainer', name: 'personal_trainer', builder: (c,s) => const PersonalTrainerScreen()),
  GoRoute(path: '/pet-care', name: 'pet_care', builder: (c,s) => const PetCareScreen()),
  GoRoute(path: '/petitions', name: 'petitions', builder: (c,s) => const PetitionsScreen()),
  GoRoute(path: '/photo-gallery', name: 'photo_gallery', builder: (c,s) => const PhotoGalleryScreen()),
  GoRoute(path: '/podcast', name: 'podcast', builder: (c,s) => const PodcastScreen()),
  GoRoute(path: '/polls', name: 'polls', builder: (c,s) => const PollsScreen()),
  GoRoute(path: '/pomodoro', name: 'pomodoro', builder: (c,s) => const PomodoroScreen()),
  GoRoute(path: '/presentation', name: 'presentation', builder: (c,s) => const PresentationScreen()),
  GoRoute(path: '/price-comparison', name: 'price_comparison', builder: (c,s) => const Price_comparisonScreen()),
  GoRoute(path: '/project-manager', name: 'project_manager', builder: (c,s) => const ProjectManagerScreen()),
  GoRoute(path: '/qr-scanner', name: 'qr_scanner', builder: (c,s) => const QRScannerScreen()),
  GoRoute(path: '/quiz', name: 'quiz', builder: (c,s) => const QuizScreen()),
  GoRoute(path: '/radio', name: 'radio', builder: (c,s) => const RadioScreen()),
  GoRoute(path: '/ratings', name: 'ratings', builder: (c,s) => const RatingsScreen()),
  GoRoute(path: '/real-estate', name: 'real_estate', builder: (c,s) => const RealEstateScreen()),
  GoRoute(path: '/recipe-book', name: 'recipe_book', builder: (c,s) => const RecipeBookScreen()),
  GoRoute(path: '/referral-system', name: 'referral_system', builder: (c,s) => const ReferralSystemScreen()),
  GoRoute(path: '/resume-builder', name: 'resume_builder', builder: (c,s) => const ResumeBuilderScreen()),
  GoRoute(path: '/reviews', name: 'reviews', builder: (c,s) => const ReviewsScreen()),
  GoRoute(path: '/ringtone-maker', name: 'ringtone_maker', builder: (c,s) => const RingtoneMakerScreen()),
  GoRoute(path: '/running-tracker', name: 'running_tracker', builder: (c,s) => const RunningTrackerScreen()),
  GoRoute(path: '/scratch-cards', name: 'scratch_cards', builder: (c,s) => const Scratch_cardsScreen()),
  GoRoute(path: '/screen-recorder', name: 'screen_recorder', builder: (c,s) => const ScreenRecorderScreen()),
  GoRoute(path: '/screen-sharing', name: 'screen_sharing', builder: (c,s) => const ScreenSharingScreen()),
  GoRoute(path: '/screenshot-editor', name: 'screenshot_editor', builder: (c,s) => const ScreenshotEditorScreen()),
  GoRoute(path: '/shopping', name: 'shopping', builder: (c,s) => const ShoppingScreen()),
  GoRoute(path: '/sleep-tracker', name: 'sleep_tracker', builder: (c,s) => const SleepTrackerScreen()),
  GoRoute(path: '/smart-home', name: 'smart_home', builder: (c,s) => const SmartHomeScreen()),
  GoRoute(path: '/social-feed', name: 'social_feed', builder: (c,s) => const SocialFeedScreen()),
  GoRoute(path: '/sound-effects', name: 'sound_effects', builder: (c,s) => const SoundEffectsScreen()),
  GoRoute(path: '/spin-wheel', name: 'spin_wheel', builder: (c,s) => const SpinWheelScreen()),
  GoRoute(path: '/sports-finder', name: 'sports_finder', builder: (c,s) => const SportsFinderScreen()),
  GoRoute(path: '/sticker-store', name: 'sticker_store', builder: (c,s) => const StickerStoreScreen()),
  GoRoute(path: '/stock-market', name: 'stock_market', builder: (c,s) => const StockMarketScreen()),
  GoRoute(path: '/stopwatch', name: 'stopwatch', builder: (c,s) => const StopwatchScreen()),
  GoRoute(path: '/surveys', name: 'surveys', builder: (c,s) => const SurveysScreen()),
  GoRoute(path: '/swimming-tracker', name: 'swimming_tracker', builder: (c,s) => const SwimmingTrackerScreen()),
  GoRoute(path: '/task-manager', name: 'task_manager', builder: (c,s) => const TaskManagerScreen()),
  GoRoute(path: '/tax-calculator', name: 'tax_calculator', builder: (c,s) => const TaxCalculatorScreen()),
  GoRoute(path: '/team-collaboration', name: 'team_collaboration', builder: (c,s) => const TeamCollaborationScreen()),
  GoRoute(path: '/testimonials', name: 'testimonials', builder: (c,s) => const TestimonialsScreen()),
  GoRoute(path: '/theatre-shows', name: 'theatre_shows', builder: (c,s) => const TheatreShowsScreen()),
  GoRoute(path: '/theme-store', name: 'theme_store', builder: (c,s) => const ThemeStoreScreen()),
  GoRoute(path: '/time-tracker', name: 'time_tracker', builder: (c,s) => const TimeTrackerScreen()),
  GoRoute(path: '/translator', name: 'translator', builder: (c,s) => const TranslatorScreen()),
  GoRoute(path: '/travel-planner', name: 'travel_planner', builder: (c,s) => const TravelPlannerScreen()),
  GoRoute(path: '/tv-streaming', name: 'tv_streaming', builder: (c,s) => const TvStreamingScreen()),
  GoRoute(path: '/unit-converter', name: 'unit_converter', builder: (c,s) => const UnitConverterScreen()),
  GoRoute(path: '/video-call', name: 'video_call', builder: (c,s) => const VideoCallScreen()),
  GoRoute(path: '/video-conference', name: 'video_conference', builder: (c,s) => const VideoConferenceScreen()),
  GoRoute(path: '/video-recording', name: 'video_recording', builder: (c,s) => const VideoRecordingScreen()),
  GoRoute(path: '/visa-guide', name: 'visa_guide', builder: (c,s) => const VisaGuideScreen()),
  GoRoute(path: '/voice-translator', name: 'voice_translator', builder: (c,s) => const VoiceTranslatorScreen()),
  GoRoute(path: '/volunteering', name: 'volunteering', builder: (c,s) => const VolunteeringScreen()),
  GoRoute(path: '/voting', name: 'voting', builder: (c,s) => const VotingScreen()),
  GoRoute(path: '/vouchers', name: 'vouchers', builder: (c,s) => const VouchersScreen()),
  GoRoute(path: '/vpn', name: 'vpn', builder: (c,s) => const VPNScreen()),
  GoRoute(path: '/water-reminder', name: 'water_reminder', builder: (c,s) => const WaterReminderScreen()),
  GoRoute(path: '/weather', name: 'weather', builder: (c,s) => const WeatherScreen()),
  GoRoute(path: '/weekly-challenges', name: 'weekly_challenges', builder: (c,s) => const Weekly_challengesScreen()),
  GoRoute(path: '/whiteboard', name: 'whiteboard', builder: (c,s) => const WhiteboardScreen()),
  GoRoute(path: '/wiki', name: 'wiki', builder: (c,s) => const WikiScreen()),
  GoRoute(path: '/wishlist', name: 'wishlist', builder: (c,s) => const WishlistScreen()),
  GoRoute(path: '/workout-planner', name: 'workout_planner', builder: (c,s) => const WorkoutPlannerScreen()),
  GoRoute(path: '/world-clock', name: 'world_clock', builder: (c,s) => const WorldClockScreen()),
  GoRoute(path: '/yoga-instructor', name: 'yoga_instructor', builder: (c,s) => const YogaInstructorScreen()),
];
