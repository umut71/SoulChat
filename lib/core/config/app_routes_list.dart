/// Tüm uygulama route path'leri (203 ekran) - All Features ekranı için.
List<String> get allRoutePaths {
  const mainPaths = [
    '/home', '/chat', '/wallet', '/marketplace', '/profile',
    '/friends', '/stories', '/notifications', '/search', '/groups',
    '/games', '/leaderboard', '/tournaments', '/achievements',
    '/music-studio', '/image-editor', '/video-editor', '/ai-tools',
    '/live', '/voice-chat', '/rewards', '/events', '/premium',
    '/settings', '/about', '/support', '/login', '/register',
  ];
  return [...mainPaths, ...extraRoutePaths];
}

List<String> get extraRoutePaths => [
  '/accounting', '/age-calculator', '/alarm-clock', '/animation-studio',
  '/appliance-manager', '/ar-filters', '/auction', '/automotive',
  '/avatar-creator', '/baby-tracker', '/backup-restore', '/banner-designer',
  '/barcode-scanner', '/beauty-tips', '/betting', '/blog', '/bmi-calculator',
  '/book-reader', '/bookmarks', '/browser', '/budget-planner', '/business-cards',
  '/calendar', '/calorie-counter', '/camping-guide', '/car-rental', '/casino',
  '/charity', '/cloud-storage', '/code-collaboration', '/collage-maker',
  '/color-picker', '/comic-creator', '/community-service', '/concert-tickets',
  '/contact-manager', '/contests', '/countdown-timer', '/coupons', '/crm-system',
  '/crypto-trading', '/currency-converter', '/cycling-tracker', '/daily-missions',
  '/dating', '/design-workspace', '/diagram', '/discount-finder', '/document-scanner',
  '/donations', '/elderly-care', '/email', '/emergency-sos', '/expense-tracker',
  '/family-organizer', '/fashion-assistant', '/file-manager', '/first-aid',
  '/fitness', '/flashlight-compass', '/flight-booking', '/flowchart', '/font-manager',
  '/food', '/freelance-marketplace', '/fundraising', '/garden-planner', '/gif-maker',
  '/gift-cards', '/goal-tracker', '/gym-finder', '/habit-tracker', '/hiking-trails',
  '/home-services', '/hotel-booking', '/icon-library', '/insurance', '/interior-design',
  '/invoice-manager', '/itinerary', '/job-board', '/kids-activities', '/language-learning',
  '/leaderboard-global', '/legal-advisor', '/loan-calculator', '/location-tracker',
  '/logo-maker', '/lottery', '/macro-tracker', '/maintenance-tracker', '/maps',
  '/media-player', '/meditation', '/meeting-scheduler', '/meme-generator', '/mind-map',
  '/monthly-events', '/movie-finder', '/music-discovery', '/music-recording', '/news',
  '/nft-marketplace', '/notes', '/nutrition-guide', '/outdoor-activities', '/parenting',
  '/password-manager', '/personal-trainer', '/pet-care', '/petitions', '/photo-gallery',
  '/podcast', '/polls', '/pomodoro', '/presentation', '/price-comparison', '/project-manager',
  '/qr-scanner', '/quiz', '/radio', '/ratings', '/real-estate', '/recipe-book',
  '/referral-system', '/resume-builder', '/reviews', '/ringtone-maker', '/running-tracker',
  '/scratch-cards', '/screen-recorder', '/screen-sharing', '/screenshot-editor',
  '/shopping', '/sleep-tracker', '/smart-home', '/social-feed', '/sound-effects',
  '/spin-wheel', '/sports-finder', '/sticker-store', '/stock-market', '/stopwatch',
  '/surveys', '/swimming-tracker', '/task-manager', '/tax-calculator', '/team-collaboration',
  '/testimonials', '/theatre-shows', '/theme-store', '/time-tracker', '/translator',
  '/travel-planner', '/tv-streaming', '/unit-converter', '/video-call', '/video-conference',
  '/video-recording', '/visa-guide', '/voice-translator', '/volunteering', '/voting',
  '/vouchers', '/vpn', '/water-reminder', '/weather', '/weekly-challenges', '/whiteboard',
  '/wiki', '/wishlist', '/workout-planner', '/world-clock', '/yoga-instructor',
];

String pathToTitle(String path) {
  if (path.startsWith('/')) path = path.substring(1);
  return path.split('-').map((s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}').join(' ');
}
