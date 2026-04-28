type Props = { t: (key: any) => string };

const guideCards = [
  { id: 'anmeldung', title: 'Anmeldung' },
  { id: 'health_insurance', title: 'Health Insurance / Krankenkasse' },
  { id: 'banking', title: 'Banking / Bankkonto' },
];

export const GuidesPage = ({ t }: Props) => {
  return (
    <section>
      <h2>{t('guides.title')}</h2>
      <div className="card-grid">
        {guideCards.map((guide) => (
          <article key={guide.id} className="card">
            <h3>{guide.title}</h3>
            <p>Bilingual, ARB-driven structure with steps and required documents.</p>
          </article>
        ))}
      </div>
    </section>
  );
};
