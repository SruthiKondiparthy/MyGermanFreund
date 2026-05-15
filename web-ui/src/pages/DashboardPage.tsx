type Props = { t: (key: any) => string };

export const DashboardPage = ({ t }: Props) => {
  return (
    <section>
      <h2>{t('dashboard.title')}</h2>
      <div className="card-grid">
        <article className="card">Core services tracker: Anmeldung / Insurance / Banking</article>
        <article className="card">Add-on services list with paywall indicators</article>
        <article className="card">Checklist progress persisted in Firestore</article>
      </div>
    </section>
  );
};
