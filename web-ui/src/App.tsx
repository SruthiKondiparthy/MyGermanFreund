import { Link, Route, Routes, useNavigate } from 'react-router-dom';

const featureCards = [
  {
    icon: '🧾',
    title: 'Bureaucratic Guidance',
    desc: 'Get step-by-step instructions on Anmeldung, visa processes, health insurance, and taxes—no more confusion!',
    route: '/bureaucratic',
  },
  {
    icon: '✅',
    title: 'Smart Checklists',
    desc: 'Stay on top of important deadlines with automated task lists that remind you what to do next.',
    route: '/checklists',
  },
  {
    icon: '📄',
    title: 'Pre-Filled Forms',
    desc: 'Save time with auto-generated documents, ready for submission to government offices.',
    route: '/prefilled',
  },
  {
    icon: '📬',
    title: 'Smart Letter Scanner',
    desc: 'Scan your official letter and we’ll break it down for you — deadlines, actions, and everything that matters.',
    route: '/scanner',
  },
  {
    icon: '🤖',
    title: 'AI Chat Assistant',
    desc: 'Get instant answers 24/7 to all your questions about moving and living in Germany',
    route: '/aichat',
  },
] as const;

const personaTabs = [
  { icon: '👨‍👩‍👧‍👦', title: 'Families', desc: 'Settle your family with ease' },
  { icon: '🧑‍💻', title: 'Freelancers', desc: 'Kickstart your business in Germany' },
  { icon: '🎓', title: 'Students', desc: 'Simplify your studies in Germany' },
  { icon: '💼', title: 'Expats', desc: 'Start your career hassle-free' },
] as const;

const LandingPage = () => {
  const navigate = useNavigate();

  return (
    <div className="landing-shell">
      <header className="hero-top">
        <div className="brand-mini">MGF</div>
        <button className="lang-toggle" type="button" aria-label="Toggle language">
          DE <span className="toggle-dot" /> EN
        </button>
      </header>

      <section className="hero-copy">
        <h1>
          Your Smart Guide to Settling in Germany <span>🇩🇪</span>
        </h1>
        <p>Step-by-step guidance for Anmeldung, visas, taxes & more!</p>
      </section>

      <img className="hero-image" src="/assets/MGF_Landingpage.jpg" alt="People with German flag" />

      <section className="cta-row">
        <button className="btn soft">Log In</button>
        <button className="btn solid">Get Started Now</button>
      </section>

      <section className="feature-scroll" aria-label="Landing features">
        {featureCards.map((card) => (
          <button key={card.title} className="feature-card" onClick={() => navigate(card.route)}>
            <div className="icon-badge">{card.icon}</div>
            <h3>{card.title}</h3>
            <p>{card.desc}</p>
          </button>
        ))}
      </section>

      <section className="persona-grid">
        {personaTabs.map((tab) => (
          <article key={tab.title} className="persona-card">
            <h3>
              <span>{tab.icon}</span> {tab.title}
            </h3>
            <p>{tab.desc}</p>
          </article>
        ))}
      </section>

      <div className="help-row">
        <span className="pen">📝</span>
        <strong>Share Your Feedback</strong>
      </div>

      <button className="buzz-fab" title="German Buzz">
        💬
      </button>

      <footer className="mobile-bottom-nav">
        <Link to="/">Home</Link>
        <a>Search</a>
        <a className="active">Buzz</a>
        <a>Cart</a>
        <a>Profile</a>
      </footer>
    </div>
  );
};

const Placeholder = ({ title }: { title: string }) => (
  <div className="placeholder-page">
    <h2>{title}</h2>
    <Link to="/">← Back</Link>
  </div>
);

export const App = () => {
  return (
    <Routes>
      <Route path="/" element={<LandingPage />} />
      <Route path="/bureaucratic" element={<Placeholder title="Bureaucratic Guidance" />} />
      <Route path="/checklists" element={<Placeholder title="Smart Checklists" />} />
      <Route path="/prefilled" element={<Placeholder title="Pre-Filled Forms" />} />
      <Route path="/scanner" element={<Placeholder title="Smart Letter Scanner" />} />
      <Route path="/aichat" element={<Placeholder title="AI Chat Assistant" />} />
    </Routes>
  );
};
