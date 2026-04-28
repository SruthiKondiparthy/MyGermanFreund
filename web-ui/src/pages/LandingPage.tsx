type Props = { t: (key: any) => string };

export const LandingPage = ({ t }: Props) => {
  return (
    <section>
      <h2>{t('landing.title')}</h2>
      <div className="card-grid">
        <article className="card">{t('landing.tabs')}</article>
        <article className="card">{t('landing.personas')}</article>
        <article className="card">Google + Email onboarding/auth</article>
        <article className="card">Premium gating and subscription states</article>
      </div>
      <button className="buzz-button" aria-label="German Buzz">
        🇩🇪 Buzz
      </button>
    </section>
  );
};
