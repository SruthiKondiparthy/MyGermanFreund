import { Link, Route, Routes, useNavigate } from 'react-router-dom';
import { ScannerPage } from './pages/ScannerPage';

const featureCards = [
  {
    icon: '/MGF_Icon.png',
    title: 'Bureaucratic Guidance',
    desc: 'Get step-by-step instructions on Anmeldung, visa processes, health insurance, and taxes—no more confusion!',
    route: '/bureaucratic',
  },
  {
    icon: '/MGF_Icon.png',
    title: 'Smart Checklists',
    desc: 'Stay on top of important deadlines with automated task lists that remind you what to do next.',
    route: '/checklists',
  },
  {
    icon: '/MGF_Icon.png',
    title: 'Pre-Filled Forms',
    desc: 'Save time with auto-generated documents, ready for submission to government offices.',
    route: '/prefilled',
  },
  {
    icon: '/MGF_Icon.png',
    title: 'Smart Letter Scanner',
    desc: 'Scan your official letter and we’ll break it down for you — deadlines, actions, and everything that matters.',
    route: '/scanner',
  },
  {
    icon: '/MGF_Icon.png',
    title: 'AI Chat Assistant',
    desc: 'Get instant answers 24/7 to all your questions about moving and living in Germany',
    route: '/aichat',
  },
] as const;

const personaTabs = [
  {
    icon: '/MGF_Icon.png',
    title: 'Families',
    desc: 'Settle your family with ease',
  },
  {
    icon: '/MGF_Icon.png',
    title: 'Freelancers',
    desc: 'Kickstart your business in Germany',
  },
  {
    icon: '/MGF_Icon.png',
    title: 'Students',
    desc: 'Simplify your studies in Germany',
  },
  {
    icon: '/MGF_Icon.png',
    title: 'Expats',
    desc: 'Start your career hassle-free',
  },
] as const;

const LandingPage = () => {
  const navigate = useNavigate();

  return (
    <div className="site-shell">
      <header className="site-topbar">
        <div className="brand-lockup">
          <img src="/logo.png" alt="MyGermanFreund" className="brand-logo" />
          <span>MyGermanFreund</span>
        </div>
        <nav>
          <a href="#features">Features</a>
          <a href="#personas">Personas</a>
          <Link to="/scanner">Scanner</Link>
        </nav>
        <button className="lang-toggle" type="button">
          DE <span className="toggle-dot" /> EN
        </button>
      </header>

      <main className="landing-main">
        <section className="hero-grid">
          <div className="hero-copy">
            <h1>
              Your Smart Guide to Settling in Germany <span>🇩🇪</span>
            </h1>
            <p>Step-by-step guidance for Anmeldung, visas, taxes & more!</p>
            <div className="cta-row">
              <button className="btn soft">Log In</button>
              <button className="btn solid">Get Started Now</button>
            </div>
          </div>

          <img className="hero-image" src="/MGF_Landingpage.jpg" alt="Landing banner" />
        </section>

        <section className="feature-section" id="features">
          <div className="section-head">
            <h2>What you can do</h2>
            <p>Scrollable cards with direct navigation to each feature.</p>
          </div>
          <div className="feature-scroll">
            {featureCards.map((card) => (
              <button key={card.title} className="feature-card" onClick={() => navigate(card.route)}>
                <img src={card.icon} alt={card.title} className="card-icon" />
                <h3>{card.title}</h3>
                <p>{card.desc}</p>
              </button>
            ))}
          </div>
        </section>

        <section className="persona-section" id="personas">
          <h2>Made for every newcomer journey</h2>
          <div className="persona-grid">
            {personaTabs.map((tab) => (
              <article key={tab.title} className="persona-card">
                <img src={tab.icon} alt={tab.title} className="persona-icon" />
                <div>
                  <h3>{tab.title}</h3>
                  <p>{tab.desc}</p>
                </div>
              </article>
            ))}
          </div>
        </section>
      </main>
    </div>
  );
};

const Placeholder = ({ title }: { title: string }) => (
  <div className="placeholder-page">
    <h2>{title}</h2>
    <p>Feature page scaffold. This route is ready for implementation.</p>
    <Link to="/">← Back to landing page</Link>
  </div>
);

export const App = () => {
  return (
    <Routes>
      <Route path="/" element={<LandingPage />} />
      <Route path="/bureaucratic" element={<Placeholder title="Bureaucratic Guidance" />} />
      <Route path="/checklists" element={<Placeholder title="Smart Checklists" />} />
      <Route path="/prefilled" element={<Placeholder title="Pre-Filled Forms" />} />
      <Route path="/scanner" element={<ScannerPage />} />
      <Route path="/aichat" element={<Placeholder title="AI Chat Assistant" />} />
    </Routes>
  );
};
