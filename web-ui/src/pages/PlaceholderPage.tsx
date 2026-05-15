import { Link } from 'react-router-dom';

type Props = {
  title: string;
};

export const PlaceholderPage = ({ title }: Props) => {
  return (
    <div className="placeholder-page">
      <h2>{title}</h2>
      <p>This section mirrors the Flutter navigation destination and can be expanded feature-by-feature.</p>
      <Link to="/" className="pill-btn">
        ← Back Home
      </Link>
    </div>
  );
};
